import 'dart:developer' as dev;
import 'package:bitdevs_project/core/cachemanager.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/models/usersdatamodels.dart';
import 'package:bitdevs_project/services/bdk_functions.dart';
import 'package:flutter/foundation.dart';

class WalletProvider extends ChangeNotifier {
  final CacheManager _cache = CacheManager();
  final WalletService _walletService = WalletService();

  Usersdatamodels? _walletData;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _error;
  String? _pendingMnemonic;
  List<Map<String, dynamic>> _walletList = [];
  bool _isbiometricsEnabled = false;

  Usersdatamodels? get walletData => _walletData;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;
  bool get hasWallet => _walletData != null;
  List<Map<String, dynamic>> get walletList => _walletList;
  String? get pendingMnemonic => _pendingMnemonic;
  bool get isBiometericEnabled => _isbiometricsEnabled;

  Future<void> loadFromCache() async {
    try {
      final walletId = await _cache.getActiveWalletId();
      if (walletId == null) return;
      final raw = await _cache.getWalletData(walletId);
      final bio = await _cache.getBiometrics();
      if (raw == null) return;
      _walletData = _mapToModel(raw);
      _isOffline = true;
      _walletList = await _walletService.getWalletList();
      _isbiometricsEnabled = bio == 'true';
      notifyListeners();
    } catch (e) {}
  }

  void updateFromSyncResponse(Map<String, dynamic> response) {
    try {
      _walletData = _mapToModel(response);
      _isOffline = false;
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<String> createWallet({Network network = Network.testnet}) async {
    _setLoading(true);
    try {
      final mnemonic = await _walletService.createWalletOffline(
        network: network,
      );
      _pendingMnemonic = mnemonic;
      _isLoading = false;
      notifyListeners();
      return mnemonic;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> saveWalletNameAndPasscode({
    required String walletName,
    required String passcode,
  }) async {
    await _walletService.saveWalletNameAndPasscode(
      walletName: walletName,
      passcode: passcode,
    );
    if (_walletData != null) {
      _walletData = _walletData!.copyWith(walletName: walletName);
    }
    notifyListeners();
  }

  Future<void> syncWallet({Network network = Network.testnet}) async {
    _setLoading(true);
    try {
      final response = await _walletService.syncWallet(network: network);
      dev.log("Full response: $response");
      dev.log("Keys: ${response.keys.toList()}");
      dev.log("Id: ${response['Id']}");
      dev.log("walletName: ${response['walletName']}");
      dev.log("total_balance: ${response['total_balance']}");
      dev.log("addresses: ${response['addresses']}");
      dev.log("balances: ${response['balances']}");
      dev.log(
        "transactions count: ${(response['all_transactions'] as List?)?.length}",
      );

      _walletList = await _walletService.getWalletList();
      _pendingMnemonic = null;
      updateFromSyncResponse(response);
    } catch (e) {
      dev.log(" $e");
      _isLoading = false;
      _isOffline = true;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> restoreWallet({
    required String mnemonic,
    Network network = Network.testnet,
  }) async {
    _setLoading(true);
    try {
      final response = await _walletService.restoreFromUserMnemonic(
        userMnemonic: mnemonic,
        network: network,
      );
      _walletList = await _walletService.getWalletList();
      updateFromSyncResponse(response);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> switchWallet({
    required String walletId,
    Network network = Network.testnet,
  }) async {
    _setLoading(true);
    try {
      final response = await _walletService.switchAndLoadWallet(
        walletId: walletId,
        network: network,
      );
      updateFromSyncResponse(response);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearWallet() async {
    _walletData = null;
    _isLoading = false;
    _isOffline = false;
    _error = null;
    _pendingMnemonic = null; // ← clear here too
    _walletList = [];
    notifyListeners();
    await _cache.clearAll();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _error = null;
    notifyListeners();
  }

  Usersdatamodels _mapToModel(Map<String, dynamic> raw) {
    return Usersdatamodels(
      Id: raw['Id'] as String,
      walletName: raw['walletName'] as String? ?? '',
      mnemonic: raw['mnemonic'] as String,
      total_balance: raw['total_balance'] as String,
      addresses: WalletAddresses.fromMap(
        raw['addresses'] as Map<String, dynamic>,
      ),
      balances: WalletBalances.fromMap(raw['balances'] as Map<String, dynamic>),
      all_transactions: List<Map<String, dynamic>>.from(
        (raw['all_transactions'] as List).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  Future<void> updateBiometrics(bool isenabled) async {
    _isbiometricsEnabled = isenabled;
    notifyListeners();
    await _cache.saveBiometrics(isenabled);
  }
}
