// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
// import 'package:flutter_test/flutter_test.dart';
// import 'package:journal_app/screens/splash_screen.dart';

// void main() {
//   testWidgets('widget tests', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const SplashScreen());

//     // await tester.pumpWidget(const MyAppView());

//     // // Verify that our counter starts at 0.
//     // expect(find.text('0'), findsOneWidget);
//     // expect(find.text('1'), findsNothing);

//     // // Tap the '+' icon and trigger a frame.
//     // await tester.tap(find.byIcon(Icons.add));
//     // await tester.pump();

//     // // Verify that our counter has incremented.
//     // expect(find.text('0'), findsNothing);
//     // expect(find.text('1'), findsOneWidget);
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/screens/splash_screen.dart';

void main() {
  testWidgets(
    'SplashScreen shows Log In and Sign Up buttons and navigates on tap',
    (WidgetTester tester) async {
      String? navigatedTo;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              navigatedTo = '/login';
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) {
              navigatedTo = '/signup';
              return const Scaffold(body: Text('Signup Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      await tester.pumpAndSettle();

      final loginFinder = find.text('Log In');
      expect(loginFinder, findsOneWidget);

      await tester.tap(loginFinder);
      await tester.pumpAndSettle();
      expect(navigatedTo, '/login');

      router.go('/');
      await tester.pumpAndSettle();

      final signupFinder = find.text('Sign up');
      expect(signupFinder, findsOneWidget);

      await tester.tap(signupFinder);
      await tester.pumpAndSettle();
      expect(navigatedTo, '/signup');
    },
  );
}
