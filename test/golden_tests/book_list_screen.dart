import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:journal_app/screens/booklist_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockBookListProvider extends Mock implements BookListProvider {}

void main() {
  testWidgets('Golden test for Book list Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  BookListCubit(listProvider: MockBookListProvider()),
            ),
            BlocProvider(
              create: (context) => ThemeCubit(),
            ),
            BlocProvider(
              create: (context) => FontCubit(),
            ),
          ],
          child: const BooklistScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(BooklistScreen),
      matchesGoldenFile('goldens/book_list_screenshot.png'),
    );
  });
}
