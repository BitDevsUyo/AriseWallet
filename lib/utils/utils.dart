import 'package:encrypt/encrypt.dart' as enc;
import 'package:local_auth/local_auth.dart';

class EncryptServices {
  static final _key = enc.Key.fromUtf8('0123456789abcdef0123456789abcdef');
  static final _iv = enc.IV.fromUtf8('abcdef9876543210');

  static String encrypt(String plainText) {
    final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String plaintext) {
    final decrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    return decrypter.decrypt64(plaintext, iv: _iv);
  }
}


class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  /// Check if device has biometric hardware available
  Future<bool> canCheckBiometrics() async {
    return await auth.canCheckBiometrics;
  }

  /// Authenticate user with fingerprint / face
  Future<bool> authenticateUser() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      print('Biometric auth error: $e');
      return false;
    }
  }
}
