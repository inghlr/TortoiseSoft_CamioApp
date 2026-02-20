import 'dart:io';

/// Loads environment variables from a .env file at project root.
/// Only the needed keys are parsed to keep it lightweight.
class EnvService {
  static final EnvService _instance = EnvService._internal();
  factory EnvService() => _instance;
  EnvService._internal();

  /// API domain, defaults to localhost:3000 if not provided.
  String apiDomain = 'localhost:3000';

  /// Whether debug builds must require user credentials.
  /// Defaults to false; when true in debug, a default admin login is used.
  bool hasUserRequired = false;

  Future<void> load() async {
    final file = File('.env');
    if (!await file.exists()) {
      return;
    }

    String? domainPart;
    String? portPart;

    final lines = await file.readAsLines();
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final idx = line.indexOf('=');
      if (idx <= 0) continue;
      final key = line.substring(0, idx).trim();
      final value = line.substring(idx + 1).trim();

      switch (key.toUpperCase()) {
        case 'API_DOMAIN':
          if (value.isNotEmpty) apiDomain = value;
          break;
        case 'DOMAIN':
          if (value.isNotEmpty) domainPart = value;
          break;
        case 'PORT':
          if (value.isNotEmpty) portPart = value;
          break;
        case 'HAS_USER_REQUIRED':
          hasUserRequired = value.toLowerCase() == 'true';
          break;
        default:
          break;
      }
    }

    // If API_DOMAIN wasn't explicitly set, compose it from DOMAIN and PORT.
    if ((apiDomain == 'localhost:3000') &&
        domainPart != null &&
        portPart != null &&
        domainPart.isNotEmpty &&
        portPart.isNotEmpty) {
      apiDomain = '$domainPart:$portPart';
    }
  }
}
