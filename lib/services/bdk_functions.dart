import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      print("$e /$st");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBitcoinWallet(Network network) async {
    await initBlockchain(network);

    final mnemonics = await Mnemonic.create(WordCount.Words12);
    final secretKey = await DescriptorSecretKey.create(
      network: network,
      mnemonic: mnemonics,
    );
    debugPrint("mnemonics: $mnemonics");

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

    final wallet = await Wallet.create(
      descriptor: externalDescriptor,
      changeDescriptor: internalDescriptor,
      network: network,
      databaseConfig: DatabaseConfig.memory(),
    );

    await wallet.sync(_electrumBlockchain!);
    debugPrint("sync complete");

    final mnemonicStr = mnemonics.toString();
    await _secureStorage.write(key: 'mnemonic', value: mnemonicStr);

    final balance = await wallet.getBalance();
    final bitcoinBalance = balance.confirmed;

    final addressInfo = await wallet.getAddress(
      addressIndex: AddressIndex.lastUnused(),
    );
    final bitcoinAddress = addressInfo.address;

    final txHistory = await wallet.listTransactions(true);
    final txHistoryJson = txHistory
        .map(
          (tx) => {
            'txid': tx.txid,
            'received': tx.received,
            'sent': tx.sent,
            'confirmationTime': tx.confirmationTime?.toString(),
          },
        )
        .toList();

    final externalDescriptorStr = await externalDescriptor.asString();

    return {
      'mnemonic': mnemonicStr,
      'bitcoin_descriptor': externalDescriptorStr,
      'bitcoin_bal': bitcoinBalance.toString(),
      'bitcoin_address': bitcoinAddress,
      'bitcoin_transactions_history': txHistoryJson,
    };
  }
}
