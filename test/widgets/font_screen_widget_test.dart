import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/screens/font_screen.dart';

class MockFontCubit extends FontCubit {
  MockFontCubit() : super();

  @override
  void changeFont(String fontName) {
    // do nothing for now
  }
}

void main() {
  testWidgets('FontScreen renders with app bar and font options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FontCubit>(
          create: (_) => MockFontCubit(),
          child: const FontScreen(),
        ),
      ),
    );

    // Check AppBar title
    expect(find.text('Change Font'), findsOneWidget);

    // Check all font options
    expect(find.text('DoveMayo'), findsOneWidget);
    expect(find.text('Gaegu'), findsOneWidget);
    expect(find.text('ComingSoon'), findsOneWidget);
    expect(find.text('Hubballi'), findsOneWidget);
  });

  testWidgets('Tapping a font tile does not crash',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FontCubit>(
          create: (_) => MockFontCubit(),
          child: const FontScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Gaegu'));
    await tester.pump();

    // No assertion needed — test passes if tap doesn't throw
  });
}
