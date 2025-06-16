void main() {
  // testWidgets(
  //   'SplashScreen shows Log In and Sign Up buttons and navigates on tap',
  //   (WidgetTester tester) async {
  //     String? navigatedTo;

  //     final router = GoRouter(
  //       initialLocation: '/',
  //       routes: [
  //         GoRoute(
  //           path: '/',
  //           builder: (context, state) => const SplashScreen(),
  //         ),
  //         GoRoute(
  //           path: '/login',
  //           builder: (context, state) {
  //             navigatedTo = '/login';
  //             return const Scaffold(body: Text('Login Screen'));
  //           },
  //         ),
  //         GoRoute(
  //           path: '/signup',
  //           builder: (context, state) {
  //             navigatedTo = '/signup';
  //             return const Scaffold(body: Text('Signup Screen'));
  //           },
  //         ),
  //       ],
  //     );

  //     await tester.pumpWidget(
  //       MaterialApp.router(
  //         routerConfig: router,
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     final loginFinder = find.text('Log In');
  //     expect(loginFinder, findsOneWidget);

  //     await tester.tap(loginFinder);
  //     await tester.pumpAndSettle();
  //     expect(navigatedTo, '/login');

  //     router.go('/');
  //     await tester.pumpAndSettle();

  //     final signupFinder = find.text('Sign up');
  //     expect(signupFinder, findsOneWidget);

  //     await tester.tap(signupFinder);
  //     await tester.pumpAndSettle();
  //     expect(navigatedTo, '/signup');
  //   },
  // );
}
