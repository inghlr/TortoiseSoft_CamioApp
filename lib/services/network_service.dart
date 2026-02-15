import 'dart:io';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }

  NetworkService._internal();

  /// Obtiene la dirección IP local del dispositivo
  Future<String> getLocalIp() async {
    try {
      // Obtener todas las interfaces de red
      final interfaces = await NetworkInterface.list();

      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          // Preferir IPv4 y excluir localhost
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

  /// Obtiene información de red formateada
  Future<String> getNetworkInfo(String port) async {
    final ip = await getLocalIp();
    return 'wss://$ip:$port';
  }
}
