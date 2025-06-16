import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:journal_app/screens/book_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryProvider extends Mock implements LibraryProvider {}

class MockBook extends Mock implements Book {}

void main() {
  testWidgets('Golden test for My Book Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetBookDetailsCubit(provider: MockLibraryProvider()),
            ),
            BlocProvider(
              create: (context) => ThemeCubit(),
            ),
            BlocProvider(
              create: (context) => FontCubit(),
            ),
          ],
          child: BookScreen(book: MockBook()),
        ),
      ),
    );

    await expectLater(
      find.byType(BookScreen),
      matchesGoldenFile('goldens/book_screen_screenshot.png'),
    );
  });
}
