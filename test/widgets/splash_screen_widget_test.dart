import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:journal_app/screens/splash_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

// These are just dummies to register with mocktail
class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

class MockUser extends Mock implements User {}

class MockUsers extends Mock implements Users {}

class MockAuthProvider extends Mock implements MyAuthProvider {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;
  late MockUsers mockUsers;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationEvent());
    registerFallbackValue(FakeAuthenticationState());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    mockUsers = MockUsers();

    when(() => mockAuthRepository.user)
        .thenAnswer((_) => Stream<User?>.value(mockUser));
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => mockUsers);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => AuthenticationBloc(authRepository: mockAuthRepository),
        child: SplashScreen(provider: MockAuthProvider()),
      ),
    );
  }

  testWidgets('renders all splash screen buttons and textfield on sign up tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final secondTab =
        find.text('Sign Up'); // or whatever your second tab label is
    expect(secondTab, findsOneWidget);
    await tester.tap(secondTab);
    await tester.pumpAndSettle();

    // Test Email TextField
    expect(find.byKey(const Key('email textfield')), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.text('abc@xyz.com'), findsOneWidget);

    // Test "Sign Up" button
    expect(find.widgetWithText(TextButton, 'Sign Up'), findsOneWidget);

    // Test "Sign Up As Moderator" button
    expect(find.widgetWithText(OutlinedButton, 'Sign Up As Moderator'),
        findsOneWidget);

    // Test "Continue With Google" OutlinedButton with Icon
    expect(find.widgetWithIcon(OutlinedButton, Icons.image),
        findsNothing); // Asset icon check workaround
    expect(find.text('Continue With Google'), findsOneWidget);
  });
  testWidgets('renders all splash screen buttons and textfield',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Test Email/username TextField
    expect(find.byKey(const Key('email/username')), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email/Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Test "Sign Up" button
    expect(find.widgetWithText(TextButton, 'Log In'), findsOneWidget);

    // Test "Continue With Google" OutlinedButton with Icon
    expect(find.widgetWithIcon(OutlinedButton, Icons.image),
        findsNothing); // Asset icon check workaround
    expect(find.text('Continue With Google'), findsOneWidget);
  });
}
