import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum walletType { bip44, bip49, bip84, bip86 }

class WalletService {
  static Blockchain? _electrumBlockchain;
  static final _secureStorage = FlutterSecureStorage();

  Future<void> initBlockchain(Network network) async {
    if (_electrumBlockchain != null) return;

    final electrumUrl = network == Network.Testnet
        ? "ssl://electrum.blockstream.info:60002"
        : "ssl://electrum.blockstream.info:50002";

    try {
      _electrumBlockchain = await Blockchain.create(
        config: BlockchainConfig.electrum(
          config: ElectrumConfig(
            url: electrumUrl,
            socks5: null,
            retry: 3,
            timeout: 5,
            stopGap: 10,
            validateDomain: true,
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
    required walletType typeOfWallet,
  }) async {
    final secretKey = await DescriptorSecretKey.create(
      network: network,
      mnemonic: mnemonics,
    );

    switch (typeOfWallet) {
      //Legacy addresses
      case walletType.bip44:
        final externalDescriptor = await Descriptor.newBip44(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.External,
        );
        final internalDescriptor = await Descriptor.newBip44(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.Internal,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};
      //Wrapped SegWit addresses
      case walletType.bip49:
        final externalDescriptor = await Descriptor.newBip49(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.External,
        );
        final internalDescriptor = await Descriptor.newBip49(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.Internal,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};
      // Native SegWit addresses
      case walletType.bip84:
        final externalDescriptor = await Descriptor.newBip84(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.External,
        );
        final internalDescriptor = await Descriptor.newBip84(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.Internal,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};
      //Taproot address i.e(Segwit v1)
      case walletType.bip86:
        final externalDescriptor = await Descriptor.newBip86(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.External,
        );
        final internalDescriptor = await Descriptor.newBip86(
          secretKey: secretKey,
          network: network,
          keychain: KeychainKind.Internal,
        );
        return {"internal": internalDescriptor, "external": externalDescriptor};
    }
  }

  Future<Map<String, dynamic>> createBitcoinWallet({
    required Network network,
    walletType typeofWallet = walletType.bip86,
    WordCount wordCount = WordCount.Words12,
  }) async {
    await initBlockchain(network);
    final mnemonic = await Mnemonic.create(WordCount.Words12);
    final printmnemonic = EncryptServices.encrypt(mnemonic.asString());
    debugPrint(printmnemonic);

    final descriptor = await _createDescriptorsForTypes(
      mnemonics: mnemonic,
      network: network,
      typeOfWallet: typeofWallet,
    );
    final externalDescriptor = descriptor['external'];
    final internalDescriptor = descriptor['internal'];

    final wallet = await Wallet.create(
      descriptor: externalDescriptor!,
      network: network,
      databaseConfig: DatabaseConfig.memory(),
    );
    await wallet.sync(_electrumBlockchain!);
    debugPrint("wallet sync to the blockchain");

    final mnemonicStr = mnemonic.toString();
    final extDescStr = await externalDescriptor.asString();
    final intDescStr = await internalDescriptor!.asString();

    final encryptedMnemonic = EncryptServices.encrypt(mnemonicStr);
    await _secureStorage.write(key: 'mnemonic', value: encryptedMnemonic);
    await _secureStorage.write(key: 'descriptor_external', value: extDescStr);
    await _secureStorage.write(key: 'descriptor_internal', value: intDescStr);
    await _secureStorage.write(
      key: 'wallet_type',
      value: typeofWallet.toString(),
    );
    //getting the users wallet account balances
    final balance = await wallet.getBalance();
    final bitcoinConfirmedbal = balance.confirmed;
    //getting the users wallet  address
    final addressInfo = await wallet.getAddress(
      addressIndex: AddressIndex.lastUnused(),
    );
    final bitcoinAddress = addressInfo.address;
    //getting the users wallet account transactions histories
    final txs = await wallet.listTransactions(true);
    final bitcointxHistory = txs
        .map(
          (tx) => {
            'txid': tx.txid,
            'received': tx.received,
            'sent': tx.sent,
            'confirmationTime': tx.confirmationTime?.toString(),
          },
        )
        .toList();
    return {
      "mnemonic": mnemonicStr,
      "bitcoin_address": bitcoinAddress,
      'bitcoin_externaldescriptor': extDescStr,
      'bitcoin_internaldescriptor': intDescStr,
      "bitcoin_transactions_history": bitcointxHistory,
      'bitcoin_bal': bitcoinConfirmedbal.toString(),
    };
  }


 Future<Map<String, dynamic>> loadStoredWallet({
  required Network network,
}) async {
  await initBlockchain(network);

  final encryptedMnemonic = await _secureStorage.read(key: 'mnemonic');
  if (encryptedMnemonic == null) throw Exception("No wallet stored");

  final mnemonicStr = EncryptServices.decrypt(encryptedMnemonic);
  final mnemonic = await Mnemonic.fromString(mnemonicStr);

  final typeStr = await _secureStorage.read(key: 'wallet_type');
  final typeOfWallet = walletType.values.firstWhere(
    (e) => e.toString() == typeStr,
  );

  final descriptor = await _createDescriptorsForTypes(
    mnemonics: mnemonic,
    network: network,
    typeOfWallet: typeOfWallet,
  );

  final wallet = await Wallet.create(
    descriptor: descriptor['external']!,
    network: network,
    databaseConfig: DatabaseConfig.memory(),
  );

  await wallet.sync(_electrumBlockchain!);

  final balance = await wallet.getBalance();
  final address = (await wallet.getAddress(
    addressIndex: AddressIndex.lastUnused(),
  )).address;

  final txs = await wallet.listTransactions(true);
  final history = txs
      .map((tx) => {
            'txid': tx.txid,
            'received': tx.received,
            'sent': tx.sent,
            'confirmationTime': tx.confirmationTime?.toString(),
          })
      .toList();

  return {
    "wallet_active": true,
    "mnemonic": mnemonicStr,
    "bitcoin_address": address,
    "bitcoin_balance": balance.confirmed.toString(),
    "bitcoin_transactions_history": history,
  };
}



  //Restoring wallet from mnemonics
  Future<Map<String, dynamic>> restoreFromUserMnemonic({
    required String userMnemonic,
    required Network network,
    walletType typeOfWallet = walletType.bip86,
  }) async {
    await initBlockchain(network);

    final mnemonic = await Mnemonic.fromString(userMnemonic.trim());

    final descriptor = await _createDescriptorsForTypes(
      mnemonics: mnemonic,
      network: network,
      typeOfWallet: typeOfWallet,
    );

    final externalDescriptor = descriptor['external'];
    final internalDescriptor = descriptor['internal'];

    final wallet = await Wallet.create(
      descriptor: externalDescriptor!,
      network: network,
      databaseConfig: DatabaseConfig.memory(),
    );

    await wallet.sync(_electrumBlockchain!);

    final balance = await wallet.getBalance();
    final address = (await wallet.getAddress(
      addressIndex: AddressIndex.lastUnused(),
    )).address;

    final txs = await wallet.listTransactions(true);
    final history = txs
        .map(
          (tx) => {
            'txid': tx.txid,
            'received': tx.received,
            'sent': tx.sent,
            'confirmationTime': tx.confirmationTime?.toString(),
          },
        )
        .toList();

    return {
      "mnemonic": userMnemonic,
      "bitcoin_address": address,
      "bitcoin_transactions_history": history,
      "bitcoin_bal": balance.confirmed.toString(),
    };
  }
}
