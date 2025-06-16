import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/screens/moderate_reviews_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewProvider extends Mock implements ReviewProvider {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUsers extends Mock implements Users {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockReviewProvider mockReviewProvider;
  late MockUser mockUser;
  late MockUsers mockMyUser;
  setUpAll(() {
    registerFallbackValue(MockUser());
    registerFallbackValue(MockUsers());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockReviewProvider = MockReviewProvider();
    mockUser = MockUser();
    mockMyUser = MockUsers();

    // Fix: Return a Stream<User?> as expected
    when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(mockUser));

    // Optional: If your AuthenticationBloc depends on getCurrentUser
    when(() => mockAuthRepo.getCurrentUser())
        .thenAnswer((_) async => mockMyUser);
  });
  testWidgets('renders ModerateReviewsScreen with app bar title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ReviewCubit(reviewProvider: mockReviewProvider),
            ),
            BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authRepository: mockAuthRepo),
            ),
          ],
          child: const ModerateReviewsScreen(),
        ),
      ),
    );

    expect(find.text('Moderate Reviews'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('shows loading animation if not loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ReviewCubit(reviewProvider: mockReviewProvider),
            ),
            BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authRepository: mockAuthRepo),
            ),
          ],
          child: const ModerateReviewsScreen(),
        ),
      ),
    );

    // This assumes the plant.json animation always appears unless state is loaded
    expect(find.byKey(const Key('plantcenter')), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('screen builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ReviewCubit(reviewProvider: mockReviewProvider),
            ),
            BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authRepository: mockAuthRepo),
            ),
          ],
          child: const ModerateReviewsScreen(),
        ),
      ),
    );

    expect(find.byType(ModerateReviewsScreen), findsOneWidget);
  });
}
