import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_config.dart';

class ConfigService {
  static const String _configKey = 'camera_streamer_config';
  late SharedPreferences _prefs;

  // Singleton
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() {
    return _instance;
  }

  ConfigService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<AppConfig> getConfig() async {
    final jsonString = _prefs.getString(_configKey);
    if (jsonString == null) {
      return AppConfig();
    }
    try {
      return AppConfig.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return AppConfig();
    }
  }

  Future<void> saveConfig(AppConfig config) async {
    await _prefs.setString(_configKey, jsonEncode(config.toJson()));
  }
}
