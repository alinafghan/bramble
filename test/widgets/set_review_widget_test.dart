import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';
import 'package:journal_app/screens/review_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewProvider extends Mock implements ReviewProvider {}

void main() {
  setUp(() {});
  testWidgets('SetReviewScreen displays date, text field, and button',
      (WidgetTester tester) async {
    // Mock book object
    final mockBook = Book(
      title: 'Test Book',
      author: 'Author Name',
      coverUrl: '',
      key: '',
      bookId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: KeyboardVisibilityProvider(
          child: BlocProvider(
            create: (context) =>
                ReviewCubit(reviewProvider: MockReviewProvider()),
            child: SetReviewScreen(book: mockBook),
          ),
        ),
      ),
    );

    // Check for the current day text
    final now = DateTime.now();
    final dateString =
        '${DateFormat('EEEE').format(now)}, ${DateFormat('dd').format(now)}  ${DateFormat('MMMM').format(now)}  ${DateFormat('yyyy').format(now)}';

    expect(find.text(dateString), findsOneWidget);

    // Check for the hint text in the TextField
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Typing...'), findsOneWidget);

    // Check for the Publish Review button
    expect(find.text('Publish Review'), findsOneWidget);

    // Check that the character count starts at 0
    expect(find.text('0/500'), findsOneWidget);
  });

  testWidgets('Typing in the TextField updates the character count',
      (WidgetTester tester) async {
    final mockBook = Book(
      title: 'Test Book',
      author: 'Author Name',
      coverUrl: '',
      key: '',
      bookId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: KeyboardVisibilityProvider(
          child: BlocProvider(
            create: (context) =>
                ReviewCubit(reviewProvider: MockReviewProvider()),
            child: SetReviewScreen(book: mockBook),
          ),
        ),
      ),
    );

    final textField = find.byKey(const Key('textfield'));
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'Hello, world!');
    await tester.pumpAndSettle();

    expect(find.text('13/500'), findsOneWidget);
  });
}
