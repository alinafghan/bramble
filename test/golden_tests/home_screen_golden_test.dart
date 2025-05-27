import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/providers/mood_provider/mood_provider.dart';
import 'package:journal_app/screens/home_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockMoodProvider extends Mock implements MoodProvider {}

void main() {
  testWidgets('Golden test for MyHomePage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MoodBloc(moodProvider: MockMoodProvider()),
          ),
          BlocProvider(
            create: (context) => CalendarBloc(),
          ),
        ],
        child: const HomeScreen(),
      )),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('goldens/homescreen_screenshot.png'),
    );
  });
}
