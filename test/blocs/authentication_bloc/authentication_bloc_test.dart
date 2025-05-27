import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FirebaseAuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('auth bloc tests', () {
    final mockAuthRepo = MockAuthRepository();
    final mockUser = MockUser();
    blocTest<AuthenticationBloc, AuthenticationState>('user authenticated',
        build: () => AuthenticationBloc(authRepository: mockAuthRepo),
        setUp: () {
          when(() => mockAuthRepo.user)
              .thenAnswer((_) => Stream.value(mockUser));
        },
        act: (bloc) => bloc.add(AuthenticationUserChanged(mockUser)),
        expect: () =>
            <AuthenticationState>[AuthenticationState.authenticated(mockUser)]);

    blocTest<AuthenticationBloc, AuthenticationState>('user unauthenticated',
        build: () => AuthenticationBloc(authRepository: mockAuthRepo),
        setUp: () {
          when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(null));
        },
        act: (bloc) => bloc.add(const AuthenticationUserChanged(null)),
        expect: () =>
            <AuthenticationState>[const AuthenticationState.unauthenticated()]);
  });
}
