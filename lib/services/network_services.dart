import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static final NetworkService instance = NetworkService._();
  NetworkService._();
  factory NetworkService() => instance;

  Future<bool> isConnected() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return true;
    }
  }

  Future<NetworkStatus> checkNetworkStrength() async {
    try {
      final result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        return NetworkStatus.noConnection;
      }
      try {
        final stopwatch = Stopwatch()..start();
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        stopwatch.stop();

        if (response.statusCode == 200) {
          final ms = stopwatch.elapsedMilliseconds;
          return ms < 3000 ? NetworkStatus.strong : NetworkStatus.weak;
        }
        return NetworkStatus.noConnection;
      } catch (e) {
        return NetworkStatus.noConnection;
      }
    } catch (e) {
      return NetworkStatus.strong;
    }
  }
}

enum NetworkStatus { strong, weak, noConnection }