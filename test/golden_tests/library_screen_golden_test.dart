import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:journal_app/screens/library_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryProvider extends Mock implements LibraryProvider {}

void main() {
  testWidgets('Golden test for Library Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LibraryBloc(libraryProvider: MockLibraryProvider()),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => FontCubit(),
          ),
        ],
        child: const LibraryScreen(),
      )),
    );

    await expectLater(
      find.byType(LibraryScreen),
      matchesGoldenFile('goldens/library_screen_screenshot.png'),
    );
  });
}
