import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:journal_app/screens/journal_list_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalProvider extends Mock implements JournalProvider {}

void main() {
  testWidgets('Golden test for Journal list Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) =>
              JournalBloc(journalProvider: MockJournalProvider()),
          child: const JournalListScreen(
            moodMap: {},
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(JournalListScreen),
      matchesGoldenFile('goldens/journal_list_screenshot.png'),
    );
  });
}
