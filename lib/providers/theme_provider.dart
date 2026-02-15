import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService themeService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider({required this.themeService}) {
    _themeMode = themeService.getThemeMode();
  }

  /// Cambia el modo de tema
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await themeService.setThemeMode(mode);
    notifyListeners();
  }

  /// Alterna entre claro y oscuro
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      // Si está en system, cambiar a oscuro
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Restaura el tema al sistema
  Future<void> resetToSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
