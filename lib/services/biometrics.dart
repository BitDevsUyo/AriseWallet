// ignore_for_file: prefer_const_constructors

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AppBiometrics {
  AppBiometrics._();

  static final AppBiometrics instance = AppBiometrics._();
  factory AppBiometrics() => instance;
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _initialized = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  bool _usesFaceID = false;
  
  static const _iosStrings = IOSAuthMessages(
    cancelButton: "Cancel",
    goToSettingsButton: 'Settings',
    goToSettingsDescription: 'Please set up your biometric authentication.',
    lockOut: 'Please re-enable your biometric authentication',
  );

  static const _androidStrings = AndroidAuthMessages(
    cancelButton: "Cancel",
    goToSettingsButton: "Settings",
    goToSettingsDescription: "Please set up your biometric authentication",
    signInTitle: 'Biometric Authentication',
    biometricHint: 'Verify identity',
  );

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!isDeviceSupported) {
        if (kDebugMode) {
          debugPrint('Device does not support biometrics');
        }
        _canCheckBiometrics = false;
        _initialized = true;
        return;
      }
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _availableBiometrics = await _localAuth.getAvailableBiometrics();
      _canCheckBiometrics = _availableBiometrics.isNotEmpty;
      
      if (Platform.isIOS) {
        _usesFaceID = _availableBiometrics.contains(BiometricType.face);
      }
      
      _initialized = true;
      
      if (kDebugMode) {
        debugPrint('Biometrics initialized');
        debugPrint('Device supported: $isDeviceSupported');
        debugPrint('Can check: $_canCheckBiometrics');
        debugPrint('Available: $_availableBiometrics');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Biometric initialization error: $e');
      }
      _canCheckBiometrics = false;
      _initialized = true;
    }
  }
  Future<bool> authenticate({String? reason}) async {
    if (!_initialized) {
      await initialize();
    }
    
    if (!_canCheckBiometrics) {
      if (kDebugMode) {
        debugPrint('Biometrics not available');
      }
      return false;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason ?? 'Biometric authentication is required',
        authMessages: const <AuthMessages>[
          _androidStrings,
          _iosStrings,
        ],
        options: AuthenticationOptions( 
          stickyAuth: true,
          biometricOnly: !kDebugMode, 
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('PlatformException: ${e.code} ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected error: $e');
      }
      return false;
    }
  }

  bool get canAuthenticate => _canCheckBiometrics;
  String get biometricTypeName {
    if (!_canCheckBiometrics) return "Biometrics";
    if (Platform.isIOS) {
      return _usesFaceID ? "Face ID" : "Touch ID";
    }
    if (_availableBiometrics.contains(BiometricType.face)) {
      return "Face Unlock";
    }
    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return "Fingerprint";
    }
    return "Biometrics";
  }
  bool get usesFaceID => Platform.isIOS && _usesFaceID;
}

final appBiometrics = AppBiometrics.instance;