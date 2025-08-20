import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      // First check if device has any network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Then check if we can actually reach the internet
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      // If connectivity check fails, try direct internet check
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
  }

  /// Check network connectivity type
  Future<ConnectivityResult> getConnectivityType() async {
    try {
      return await Connectivity().checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> isConnectedToWifi() async {
    final connectivityResult = await getConnectivityType();
    return connectivityResult == ConnectivityResult.wifi;
  }

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile() async {
    final connectivityResult = await getConnectivityType();
    return connectivityResult == ConnectivityResult.mobile;
  }

  /// Get network status description
  String getNetworkStatusDescription(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      case ConnectivityResult.vpn:
        return 'Connected via VPN';
      case ConnectivityResult.bluetooth:
        return 'Connected via Bluetooth';
      case ConnectivityResult.other:
        return 'Connected to Other Network';
      case ConnectivityResult.none:
        return 'No Network Connection';
    }
  }

  /// Test connection to a specific URL
  Future<bool> testConnectionToUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final result = await InternetAddress.lookup(uri.host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
