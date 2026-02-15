import 'dart:io';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }

  NetworkService._internal();

  /// Gets the local IP address of the device
  Future<String> getLocalIp() async {
    try {
      // Get all network interfaces
      final interfaces = await NetworkInterface.list();

      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          // Prefer IPv4 and exclude localhost
          if (address.type == InternetAddressType.IPv4 &&
              !address.address.startsWith('127.')) {
            return address.address;
          }
        }
      }

      return 'IP not found';
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Gets formatted network information
  Future<String> getNetworkInfo(String port) async {
    final ip = await getLocalIp();
    return 'wss://$ip:$port';
  }
}
