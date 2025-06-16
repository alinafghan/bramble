import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/screens/settings_screen.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider<AuthenticationBloc>(
            create: (_) =>
                AuthenticationBloc(authRepository: AuthRepository())),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/home/settings',
          routes: [
            GoRoute(
              path: '/home/settings',
              builder: (_, __) => child,
            ),
            GoRoute(
              path: '/home/settings/font',
              builder: (_, __) => const Scaffold(body: Text('Font Page')),
            ),
            GoRoute(
              path: '/home/settings/about',
              builder: (_, __) => const Scaffold(body: Text('About Page')),
            ),
            GoRoute(
              path: '/home/settings/profile',
              builder: (_, __) => const Scaffold(body: Text('Profile Page')),
            ),
            GoRoute(
              path: '/',
              builder: (_, __) => const Scaffold(body: Text('Home Page')),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('Navigates to font settings screen', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SettingsScreen()));

    await tester.tap(find.text('Font'));
    await tester.pumpAndSettle();

    expect(find.text('Font Page'), findsOneWidget);
  });
  testWidgets('Navigates to About Us screen', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SettingsScreen()));

    await tester.tap(find.text('About Us'));
    await tester.pumpAndSettle();

    expect(find.text('About Page'), findsOneWidget);
  });
  testWidgets('Navigates to Edit Profile screen', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SettingsScreen()));

    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile Page'), findsOneWidget);
  });
  testWidgets('Displays sign out confirmation dialog', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SettingsScreen()));

    // Find the 'Sign Out' tile and tap it
    final signOutTile = find.byKey(const ValueKey('Sign out 1'));
    expect(signOutTile, findsOneWidget);
    await tester.tap(signOutTile);
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Now expect dialog contents
    expect(find.byKey(const Key('signoutkey')), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.byKey(const ValueKey('Sign out 2')), findsOneWidget);
  });

  testWidgets('Displays delete account confirmation dialog', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SettingsScreen()));

    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    expect(
        find.text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });
}
