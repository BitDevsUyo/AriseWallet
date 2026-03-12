import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/core/cachemanager.dart';
import 'package:bitdevs_project/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

enum WalletType { bip44, bip49, bip84, bip86 }

class WalletInfo {
  final Address address;
  final BigInt balance;
  final List<Map<String, dynamic>> transactions;
  final WalletType type;
  final Wallet wallet;

  WalletInfo({
    required this.address,
    required this.balance,
    required this.transactions,
    required this.type,
    required this.wallet,
  });
}

class WalletService {
  static Blockchain? _electrumBlockchain;
  final CacheManager _cacheManager = CacheManager();
  final Uuid _uuid = Uuid();

  static Future<void> initBdk() async {
    try {
      await Mnemonic.create(WordCount.words12);
      debugPrint('BDK native bindings initialized successfully');
    } catch (e) {
      debugPrint('BDK init failed: $e');
      rethrow;
    }
  }

  Future<void> initBlockchain(Network network) async {
    if (_electrumBlockchain != null) return;

    final electrumUrl = network == Network.testnet
        ? "ssl://testnet.aranguren.org:51002"
        : "ssl://electrum.blockstream.info:50002";
    try {
      _electrumBlockchain = await Blockchain.create(
        config: BlockchainConfig.electrum(
          config: ElectrumConfig(
            url: electrumUrl,
            socks5: null,
            retry: 5,
            timeout: 10,
            stopGap: BigInt.from(10),
            validateDomain: false,
          ),
        ),
      );
    } catch (e, st) {
      debugPrint("$e /$st");
      rethrow;
    }
  }

  Future<Map<String, Descriptor>> _createDescriptorsForTypes({
    required Mnemonic mnemonics,
    required Network network,
    required WalletType typeOfWallet,
  }) async {
    final secretKey = await DescriptorSecretKey.create(
      network: network,
      mnemonic: mnemonics,
    );

    switch (typeOfWallet) {
      case WalletType.bip44:
        final externalDescriptor = await Descriptor.newBip44(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.externalChain,
        );
        final internalDescriptor = await Descriptor.newBip44(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.internalChain,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};

      case WalletType.bip49:
        final externalDescriptor = await Descriptor.newBip49(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.externalChain,
        );
        final internalDescriptor = await Descriptor.newBip49(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.internalChain,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};

      case WalletType.bip84:
        final externalDescriptor = await Descriptor.newBip84(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.externalChain,
        );
        final internalDescriptor = await Descriptor.newBip84(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.internalChain,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};

      case WalletType.bip86:
        final externalDescriptor = await Descriptor.newBip86(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.externalChain,
        );
        final internalDescriptor = await Descriptor.newBip86(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.internalChain,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};
    }
  }

  Future<WalletInfo> _getWalletInfo({
    required Mnemonic mnemonic,
    required Network network,
    required WalletType type,
  }) async {
    final descriptor = await _createDescriptorsForTypes(
      mnemonics: mnemonic,
      network: network,
      typeOfWallet: type,
    );

    final wallet = await Wallet.create(
      descriptor: descriptor['external']!,
      network: network,
      databaseConfig: DatabaseConfig.memory(),
    );

    await wallet.sync(blockchain: _electrumBlockchain!);
    final balance = wallet.getBalance();
    final addressInfo = wallet.getAddress(
      addressIndex: AddressIndex.lastUnused(),
    );

    final txs = wallet.listTransactions(includeRaw: true);
    final txHistory = txs
        .map(
          (tx) => {
            'txid': tx.txid,
            'received': tx.received.toString(),
            'sent': tx.sent.toString(),
            'confirmationTime': tx.confirmationTime?.toString(),
            'wallet_type': type.toString(),
          },
        )
        .toList();

    return WalletInfo(
      address: addressInfo.address,
      balance: balance.confirmed,
      transactions: txHistory,
      type: type,
      wallet: wallet,
    );
  }

  Future<String> createWalletOffline({
    required Network network,
    WordCount wordCount = WordCount.words12,
  }) async {
    final mnemonic = await Mnemonic.create(wordCount);
    final mnemonicStr = mnemonic.toString();
    final walletId = _uuid.v4();

    final encryptedMnemonic = EncryptServices.encrypt(mnemonicStr);
    await _cacheManager.saveMnemonic(encryptedMnemonic, walletId);
    await _cacheManager.saveWalletId(walletId);
    await _cacheManager.saveActiveWalletId(walletId);

    return mnemonicStr;
  }

  Future<void> saveWalletNameAndPasscode({
    required String walletName,
    required String passcode,
  }) async {
    final walletId = await _cacheManager.getActiveWalletId();
    if (walletId == null) throw Exception("No active wallet");
    final encryptedPasscode = EncryptServices.encrypt(passcode);
    await _cacheManager.addWalletToList(walletId, walletName);
    await _cacheManager.savePasscode(encryptedPasscode);
    debugPrint("Added to list: $walletName for $walletId");
  }

  Future<Map<String, dynamic>> syncWallet({required Network network}) async {
    await initBlockchain(network);

    final walletId = await _cacheManager.getActiveWalletId();
    if (walletId == null) throw Exception("No active wallet");

    final encryptedMnemonic = await _cacheManager.getMnemonic(walletId);
    if (encryptedMnemonic == null) {
      throw Exception("No mnemonic for wallet: $walletId");
    }

    final mnemonicStr = EncryptServices.decrypt(encryptedMnemonic);
    final mnemonic = await Mnemonic.fromString(mnemonicStr);

    final bip44Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip44,
    );
    final bip49Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip49,
    );
    final bip84Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip84,
    );
    final bip86Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip86,
    );

    final totalBalance =
        bip44Info.balance +
        bip49Info.balance +
        bip84Info.balance +
        bip86Info.balance;

    final allTransactions = [
      ...bip44Info.transactions,
      ...bip49Info.transactions,
      ...bip84Info.transactions,
      ...bip86Info.transactions,
    ];

    final walletList = await _cacheManager.getWalletList();
    final walletEntry = walletList.firstWhere(
      (w) => w['id'] == walletId,
      orElse: () => {'id': walletId, 'name': ''},
    );
    final walletName = walletEntry['name'] as String? ?? '';
    debugPrint("Wallet list: $walletList");

    final result = {
      "Id": walletId,
      "walletName": walletName,
      "mnemonic": mnemonicStr,
      "total_balance": totalBalance.toString(),
      "addresses": {
        "bip44": bip44Info.address.asString(),
        "bip49": bip49Info.address.asString(),
        "bip84": bip84Info.address.asString(),
        "bip86": bip86Info.address.asString(),
      },
      "balances": {
        "bip44": bip44Info.balance.toString(),
        "bip49": bip49Info.balance.toString(),
        "bip84": bip84Info.balance.toString(),
        "bip86": bip86Info.balance.toString(),
      },
      "all_transactions": allTransactions,
    };

    await _cacheManager.saveWalletData(result, walletId);
    await _cacheManager.saveTotalBalance(totalBalance.toString(), walletId);

    return result;
  }

  Future<Map<String, dynamic>> loadStoredWallet({
    required Network network,
  }) async {
    await initBlockchain(network);

    final walletId = await _cacheManager.getActiveWalletId();
    if (walletId == null) throw Exception("No active wallet");

    final encryptedMnemonic = await _cacheManager.getMnemonic(walletId);
    if (encryptedMnemonic == null) {
      throw Exception("No mnemonic for wallet: $walletId");
    }

    final mnemonicStr = EncryptServices.decrypt(encryptedMnemonic);
    final mnemonic = await Mnemonic.fromString(mnemonicStr);

    final bip44Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip44,
    );
    final bip49Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip49,
    );
    final bip84Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip84,
    );
    final bip86Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip86,
    );

    final totalBalance =
        bip44Info.balance +
        bip49Info.balance +
        bip84Info.balance +
        bip86Info.balance;

    final allTransactions = [
      ...bip44Info.transactions,
      ...bip49Info.transactions,
      ...bip84Info.transactions,
      ...bip86Info.transactions,
    ];

    final result = {
      "Id": walletId,
      "mnemonic": mnemonicStr,
      "total_balance": totalBalance.toString(),
      "addresses": {
        "bip44": bip44Info.address.asString(),
        "bip49": bip49Info.address.asString(),
        "bip84": bip84Info.address.asString(),
        "bip86": bip86Info.address.asString(),
      },
      "balances": {
        "bip44": bip44Info.balance.toString(),
        "bip49": bip49Info.balance.toString(),
        "bip84": bip84Info.balance.toString(),
        "bip86": bip86Info.balance.toString(),
      },
      "all_transactions": allTransactions,
    };

    await _cacheManager.saveWalletData(result, walletId);
    await _cacheManager.saveTotalBalance(totalBalance.toString(), walletId);

    return result;
  }

  Future<Map<String, dynamic>> switchAndLoadWallet({
    required String walletId,
    required Network network,
  }) async {
    await _cacheManager.saveActiveWalletId(walletId);
    await _cacheManager.saveWalletId(walletId);
    return await loadStoredWallet(network: network);
  }

  Future<List<Map<String, dynamic>>> getWalletList() async {
    return await _cacheManager.getWalletList();
  }

  Future<Map<String, dynamic>> restoreFromUserMnemonic({
    required String userMnemonic,
    required Network network,
  }) async {
    await initBlockchain(network);

    final mnemonic = await Mnemonic.fromString(userMnemonic.trim());

    final bip44Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip44,
    );
    final bip49Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip49,
    );
    final bip84Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip84,
    );
    final bip86Info = await _getWalletInfo(
      mnemonic: mnemonic,
      network: network,
      type: WalletType.bip86,
    );

    final totalBalance =
        bip44Info.balance +
        bip49Info.balance +
        bip84Info.balance +
        bip86Info.balance;

    final allTransactions = [
      ...bip44Info.transactions,
      ...bip49Info.transactions,
      ...bip84Info.transactions,
      ...bip86Info.transactions,
    ];

    final walletId = _uuid.v4();
    final encryptedMnemonic = EncryptServices.encrypt(userMnemonic.trim());

    await _cacheManager.saveMnemonic(encryptedMnemonic, walletId);
    await _cacheManager.saveWalletId(walletId);
    await _cacheManager.saveActiveWalletId(walletId);

    final result = {
      "Id": walletId,
      "mnemonic": userMnemonic.trim(),
      "total_balance": totalBalance.toString(),
      "addresses": {
        "bip44": bip44Info.address.asString(),
        "bip49": bip49Info.address.asString(),
        "bip84": bip84Info.address.asString(),
        "bip86": bip86Info.address.asString(),
      },
      "balances": {
        "bip44": bip44Info.balance.toString(),
        "bip49": bip49Info.balance.toString(),
        "bip84": bip84Info.balance.toString(),
        "bip86": bip86Info.balance.toString(),
      },
      "all_transactions": allTransactions,
    };

    await _cacheManager.saveWalletData(result, walletId);
    return result;
  }

  Future<Wallet> getWalletForAddress({
    required String address,
    required Network network,
  }) async {
    await initBlockchain(network);

    final walletId = await _cacheManager.getActiveWalletId();
    if (walletId == null) throw Exception("No active wallet");

    final encryptedMnemonic = await _cacheManager.getMnemonic(walletId);
    if (encryptedMnemonic == null) throw Exception("No mnemonic stored");

    final mnemonicStr = EncryptServices.decrypt(encryptedMnemonic);
    final mnemonic = await Mnemonic.fromString(mnemonicStr);

    for (var type in WalletType.values) {
      final info = await _getWalletInfo(
        mnemonic: mnemonic,
        network: network,
        type: type,
      );
      if (info.address == address) {
        return info.wallet;
      }
    }

    throw Exception("Address not found in any wallet type");
  }

  /*Future<String> sendTransaction({...}) async { ... }*/
}
