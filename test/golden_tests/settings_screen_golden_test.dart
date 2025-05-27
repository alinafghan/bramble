import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/screens/settings_screen.dart';

void main() {
  testWidgets('Golden test for MySettingsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settingsscreen_screenshot.png'),
    );
  });
}
