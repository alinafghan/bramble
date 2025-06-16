import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/book_card.dart';
import 'package:mocktail/mocktail.dart';

class MockBookListCubit extends Mock implements BookListCubit {}

class MockHttpClient extends Mock implements HttpClient {}

class DummyNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockBookListCubit mockBookListCubit;
  late Book testBook;

  setUp(() {
    mockBookListCubit = MockBookListCubit();
    testBook = Book(
      bookId: 1,
      title: 'Test Title',
      author: 'Test Author',
      coverUrl: 'https://example.com/cover.jpg',
      key: 'test-key',
    );
  });

  Widget makeTestableWidget(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => child,
        ),
        GoRoute(
          path: '/book',
          builder: (_, state) {
            final book = state.extra as Book;
            return Scaffold(body: Text('Book Detail: ${book.title}'));
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider.value(
          value: mockBookListCubit,
          child: child!,
        );
      },
    );
  }

  testWidgets('renders book title and author', (tester) async {
    await tester.pumpWidget(makeTestableWidget(BookCard(book: testBook)));

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Author'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('taps card and navigates to /book', (tester) async {
    await tester.pumpWidget(makeTestableWidget(BookCard(book: testBook)));

    await tester.tap(find.byKey(const Key('BookCardGestureDetector')));
    await tester.pumpAndSettle();

    expect(find.text('Book Detail: Test Title'), findsOneWidget);
  });

  testWidgets('shows add book dialog on FAB press', (tester) async {
    await tester.pumpWidget(makeTestableWidget(BookCard(book: testBook)));

    // Tap the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump the dialog

    expect(find.text('Add book to your book list?'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });
}
