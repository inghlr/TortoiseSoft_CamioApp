import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  late SharedPreferences _prefs;
  static const String _themeModeKey = 'app_theme_mode';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Obtiene el modo de tema guardado (0: system, 1: light, 2: dark)
  ThemeMode getThemeMode() {
    final value = _prefs.getInt(_themeModeKey) ?? 0;
    return ThemeMode.values[value];
  }

  /// Guarda el modo de tema
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(_themeModeKey, themeMode.index);
  }

  /// Obtiene si el tema es oscuro actualmente
  bool isDarkMode(Brightness brightness) {
    return brightness == Brightness.dark;
  }
}
