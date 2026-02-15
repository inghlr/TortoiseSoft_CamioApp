import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService themeService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider({required this.themeService}) {
    _themeMode = themeService.getThemeMode();
  }

  /// Changes the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await themeService.setThemeMode(mode);
    notifyListeners();
  }

  /// Toggles between light and dark
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      // If it's in system mode, change to dark
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Restores the theme to system
  Future<void> resetToSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
