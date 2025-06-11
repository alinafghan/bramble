import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUsers extends Mock implements Users {}

void main() {
  group('auth bloc tests', () {
    final mockAuthRepo = MockAuthRepository();
    final mockUser = MockUser();
    final mockMyUser = MockUsers();
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

    blocTest<AuthenticationBloc, AuthenticationState>(
      'get user',
      build: () => AuthenticationBloc(authRepository: mockAuthRepo),
      setUp: () {
        when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(null));
        when(() => mockAuthRepo.getCurrentUserFromFirebase())
            .thenAnswer((_) async => mockMyUser);
      },
      act: (bloc) => bloc.add(GetUserEvent()),
      skip: 1,
      expect: () => <AuthenticationState>[
        const AuthenticationState.unauthenticated(),
        GetUserLoaded(myUser: mockMyUser),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'get user failed',
      build: () => AuthenticationBloc(authRepository: mockAuthRepo),
      setUp: () {
        when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(null));
        when(() => mockAuthRepo.getCurrentUserFromFirebase())
            .thenThrow(Exception('Failed to get user test'));
      },
      act: (bloc) => bloc.add(GetUserEvent()),
      skip: 1,
      expect: () => <AuthenticationState>[
        const GetUserFailed(message: 'Exception: Failed to get user test'),
        const AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'add profile pic test',
      build: () => AuthenticationBloc(authRepository: mockAuthRepo),
      setUp: () {
        when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(null));
        when(() => mockAuthRepo.addProfilePic(any()))
            .thenAnswer((_) async => mockMyUser);
        when(() => mockAuthRepo.getCurrentUserFromFirebase())
            .thenAnswer((_) async => mockMyUser);
      },
      act: (bloc) =>
          bloc.add(const AddProfilePicEvent(profileUrl: 'profile pic')),
      skip: 1,
      expect: () => <AuthenticationState>[
        const AuthenticationState.unauthenticated(),
        AddProfilePicLoaded(myUser: mockMyUser),
        GetUserLoaded(myUser: mockMyUser),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'add profile pic test failed',
      build: () => AuthenticationBloc(authRepository: mockAuthRepo),
      setUp: () {
        when(() => mockAuthRepo.user).thenAnswer((_) => Stream.value(null));
        when(() => mockAuthRepo.addProfilePic(any()))
            .thenThrow(Exception('Failed successfully to get pfp'));
      },
      act: (bloc) =>
          bloc.add(const AddProfilePicEvent(profileUrl: 'profile pic')),
      skip: 1,
      expect: () => <AuthenticationState>[
        const AddProfilePicFailure(
            message: 'Exception: Failed successfully to get pfp'),
        const AuthenticationState.unauthenticated(),
      ],
    );
  });
}
