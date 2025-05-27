import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/screens/splash_screen.dart';

void main() {
  testWidgets('Golden test for Splash Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_screen_screenshot.png'),
    );
  });
}
