import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/utils/popup_menu.dart';

void main() {
  Widget buildTestableWidget(
      {required String selectedVal, required bool isModerator}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(
                  body: Row(
                    children: [
                      PopupMenu(
                          selectedVal: selectedVal, isModerator: isModerator),
                    ],
                  ),
                )),
        GoRoute(
            path: '/home',
            builder: (_, __) => const Scaffold(body: Text('Diary Page'))),
        GoRoute(
            path: '/booklist',
            builder: (_, __) => const Scaffold(body: Text('Book Page'))),
        GoRoute(
            path: '/reviews',
            builder: (_, __) => const Scaffold(body: Text('Reviews Page'))),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  group('PopupMenu Widget Tests', () {
    testWidgets('navigates to Diary when Diary is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          buildTestableWidget(selectedVal: 'Book', isModerator: false));

      // Open menu
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap Diary
      await tester.tap(find.text('Diary'));
      await tester.pumpAndSettle();

      // Expect Diary page content
      expect(find.text('Diary Page'), findsOneWidget);
    });

    testWidgets('navigates to Book when Book is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          buildTestableWidget(selectedVal: 'Diary', isModerator: false));

      // Open menu
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap Book
      await tester.tap(find.text('Book'));
      await tester.pumpAndSettle();

      // Expect Book page content
      expect(find.text('Book Page'), findsOneWidget);
    });

    testWidgets('navigates to Reviews when Reviews is tapped (moderator only)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          buildTestableWidget(selectedVal: 'Diary', isModerator: true));

      // Open menu
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap Reviews
      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();

      // Expect Reviews page content
      expect(find.text('Reviews Page'), findsOneWidget);
    });
  });
}
