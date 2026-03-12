import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheKeys {
  static const String isDarkMode = "isDarkMode";
  static const String id = 'wallet_id';
  static const String mnemonics = 'mnemonics';
  static const String passcode = "passcode";
  static const String biometerics = "biometrics";
  static const String walletData = "wallet_data";
  static const String totalBalance = "total_balance";
  static const String allTransactions = "all_transactions";
  static const String walletList = "wallet_list";
  static const String activeWalletId = "active_wallet_id";
}

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> init() async {
    dev.log('CacheManager initialized');
  }


  Future<void> addWalletToList(String walletId, String walletName) async {
    try {
      final existing = await getWalletList();
      existing.removeWhere((w) => w['id'] == walletId);
      existing.add({"id": walletId, "name": walletName});
      await _storage.write(
        key: CacheKeys.walletList,
        value: jsonEncode(existing),
      );
      dev.log('Wallet added to list: $walletName ($walletId)');
    } catch (e) {
      dev.log('Error adding wallet to list: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWalletList() async {
    try {
      final raw = await _storage.read(key: CacheKeys.walletList);
      if (raw == null) return [];
      return List<Map<String, dynamic>>.from(jsonDecode(raw));
    } catch (e) {
      dev.log('Error getting wallet list: $e');
      return [];
    }
  }

  Future<void> removeWalletFromList(String walletId) async {
    try {
      final existing = await getWalletList();
      existing.removeWhere((w) => w['id'] == walletId);
      await _storage.write(
        key: CacheKeys.walletList,
        value: jsonEncode(existing),
      );
    } catch (e) {
      dev.log('Error removing wallet from list: $e');
    }
  }


  Future<void> saveActiveWalletId(String walletId) async {
    await _storage.write(key: CacheKeys.activeWalletId, value: walletId);
  }
  Future<String?> getActiveWalletId() async {
    return await _storage.read(key: CacheKeys.activeWalletId);
  }
  Future<void> saveWalletId(String id) async {
    await _storage.write(key: CacheKeys.id, value: id);
  }


  Future<bool> saveMnemonic(String mnemonic, String walletId) async {
    try {
      await _storage.write(
        key: '${CacheKeys.mnemonics}_$walletId',
        value: mnemonic,
      );
      dev.log('Mnemonic saved for wallet: $walletId');
      return true;
    } catch (e) {
      dev.log('Error saving mnemonic: $e');
      return false;
    }
  }

  Future<String?> getMnemonic(String walletId) async {
    try {
      return await _storage.read(key: '${CacheKeys.mnemonics}_$walletId');
    } catch (e) {
      dev.log('Error getting mnemonic: $e');
      return null;
    }
  }

  Future<bool> deleteMnemonic(String walletId) async {
    try {
      await _storage.delete(key: '${CacheKeys.mnemonics}_$walletId');
      return true;
    } catch (e) {
      dev.log('Error deleting mnemonic: $e');
      return false;
    }
  }

  // --- Passcode ---

  Future<bool> savePasscode(String passcode) async {
    try {
      await _storage.write(key: CacheKeys.passcode, value: passcode);
      return true;
    } catch (e) {
      dev.log('Error saving passcode: $e');
      return false;
    }
  }

  Future<String?> getPasscode() async {
    try {
      return await _storage.read(key: CacheKeys.passcode);
    } catch (e) {
      dev.log('Error getting passcode: $e');
      return null;
    }
  }


  Future<bool> saveApptheme(String value) async {
    try {
      await _storage.write(key: CacheKeys.isDarkMode, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getApptheme() async {
    try {
      return await _storage.read(key: CacheKeys.isDarkMode);
    } catch (e) {
      dev.log('Error getting app theme: $e');
      return null;
    }
  }


  Future<bool> saveWalletData(
      Map<String, dynamic> walletData, String walletId) async {
    try {
      await _storage.write(
        key: '${CacheKeys.walletData}_$walletId',
        value: jsonEncode(walletData),
      );
      dev.log('Wallet data saved for: $walletId');
      return true;
    } catch (e) {
      dev.log('Error saving wallet data: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getWalletData(String walletId) async {
    try {
      final jsonString = await _storage.read(
        key: '${CacheKeys.walletData}_$walletId',
      );
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      dev.log('Error getting wallet data: $e');
      return null;
    }
  }

  Future<bool> saveTotalBalance(String balance, String walletId) async {
    try {
      await _storage.write(
        key: '${CacheKeys.totalBalance}_$walletId',
        value: balance,
      );
      return true;
    } catch (e) {
      dev.log('Error saving total balance: $e');
      return false;
    }
  }

  Future<String?> getTotalBalance(String walletId) async {
    try {
      return await _storage.read(key: '${CacheKeys.totalBalance}_$walletId');
    } catch (e) {
      dev.log('Error getting total balance: $e');
      return null;
    }
  }


Future<bool> saveBiometrics(bool value) async {
  try {
    await _storage.write(key: CacheKeys.biometerics, value: value.toString());
    return true;
  } catch (e) {
    dev.log('Error saving biometrics: $e');
    return false;
  }
}
  Future<String?> getBiometrics() async {
    try {
      return await _storage.read(key: CacheKeys.biometerics);
    } catch (e) {
      dev.log('Error getting biometrics: $e');
      return null;
    }
  }


  Future<bool> hasWallet() async {
    try {
      final list = await getWalletList();
      return list.isNotEmpty;
    } catch (e) {
      dev.log('Error checking wallet existence: $e');
      return false;
    }
  }

  Future<bool> deleteWallet(String walletId) async {
    try {
      await deleteMnemonic(walletId);
      await _storage.delete(key: '${CacheKeys.walletData}_$walletId');
      await _storage.delete(key: '${CacheKeys.totalBalance}_$walletId');
      await _storage.delete(key: '${CacheKeys.allTransactions}_$walletId');
      await removeWalletFromList(walletId);
      dev.log('Wallet deleted: $walletId');
      return true;
    } catch (e) {
      dev.log('Error deleting wallet: $e');
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      await _storage.deleteAll();
      dev.log('All cache cleared successfully');
      return true;
    } catch (e) {
      dev.log('Error clearing all cache: $e');
      return false;
    }
  }
}