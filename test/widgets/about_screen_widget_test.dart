import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/screens/about_screen.dart';

void main() {
  group('AboutScreen Widget Tests', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
        initialLocation: '/about',
        routes: [
          GoRoute(
            path: '/about',
            builder: (_, __) => const AboutScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (_, __) => const Placeholder(), // dummy home route
          ),
        ],
      );
    });

    Widget makeTestableWidget() {
      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets('renders AboutScreen with title and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle(); // Wait for routing

      expect(find.text('About Us'), findsOneWidget);
      expect(find.textContaining('Hello. We\'re happy to have you here'),
          findsOneWidget);
    });
  });
}
