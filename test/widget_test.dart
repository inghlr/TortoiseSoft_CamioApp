// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_caminout_app/main.dart';
import 'package:flutter_caminout_app/services/auth_service.dart';
import 'package:flutter_caminout_app/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App shows auth screen when no active session', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final themeService = ThemeService();
    await themeService.init();
    await tester.pumpWidget(
      CameraStreamerApp(themeService: themeService, authService: AuthService()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Caminout'), findsOneWidget);
  });
}
