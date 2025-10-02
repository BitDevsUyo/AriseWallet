import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/models/usersdatamodels.dart';
import 'package:bitdevs_project/services/bdk_functions.dart';
import 'package:flutter/material.dart';

class Walletprovider with ChangeNotifier {

  bool _isloading = false;
  bool get isloading => _isloading;

  Usersdatamodels? _usersWalletData;
  Usersdatamodels? get usersWalletData => _usersWalletData;

  Future<void> createWallet({required Network network}) async {
    _isloading = true;
    notifyListeners();
    try {
      final walletdata = await WalletService().createBitcoinWallet(network);
      debugPrint('Wallet data response: $walletdata');
      _usersWalletData = Usersdatamodels(
        walletdata['mnemonic'],
        walletdata['bitcoin_address'],
        walletdata['bitcoin_descriptor'],
        walletdata['bitcoin_transactions_history'],
        walletdata['bitcoin_bal'],
      );
      debugPrint('this users wallet datas are:$_usersWalletData');
    } catch (e) {
      debugPrint("Wallet creation failed: $e");
      _usersWalletData = null;
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
