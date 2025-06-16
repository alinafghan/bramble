import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/screens/settings_screen.dart';

void main() {
  testWidgets('Golden test for MySettingsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ThemeCubit(),
            ),
            BlocProvider(
              create: (context) => FontCubit(),
            ),
          ],
          child: const SettingsScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settingsscreen_screenshot.png'),
    );
  });
}
