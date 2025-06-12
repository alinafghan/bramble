import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MyAuthProvider authProvider;
  late MockAuthRepository mockAuthRepository;
  late Users testUser;
  late User mockFirebaseUser;
  late UserCredential mockUserCredential;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authProvider = MyAuthProvider(repo: mockAuthRepository);
    testUser = Users(
        userId: '123',
        email: 'test@example.com',
        username: 'testuser',
        mod: false);
    mockFirebaseUser = MockUser();
    mockUserCredential = MockUserCredential();
  });

  group('MyAuthProvider', () {
    test('emailSignUp calls AuthRepository.emailSignUp', () async {
      when(() => mockAuthRepository.emailSignUp(testUser, 'password'))
          .thenAnswer((_) async => testUser);

      final result = await authProvider.emailSignUp(testUser, 'password');

      expect(result, testUser);
      verify(() => mockAuthRepository.emailSignUp(testUser, 'password'))
          .called(1);
    });

    test('emailLogin calls AuthRepository.emailLogin', () async {
      when(() => mockAuthRepository.emailLogin('test@example.com', 'password'))
          .thenAnswer((_) async => mockFirebaseUser);

      final result =
          await authProvider.emailLogin('test@example.com', 'password');

      expect(result, mockFirebaseUser);
      verify(() =>
              mockAuthRepository.emailLogin('test@example.com', 'password'))
          .called(1);
    });

    test('signOut calls AuthRepository.signOut', () async {
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) async => mockFirebaseUser);

      final result = await authProvider.signOut();

      expect(result, mockFirebaseUser);
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('signUpWithGoogle calls AuthRepository.signUpWithGoogle', () async {
      when(() => mockAuthRepository.signUpWithGoogle())
          .thenAnswer((_) async => mockUserCredential);

      final result = await authProvider.signUpWithGoogle();

      expect(result, mockUserCredential);
      verify(() => mockAuthRepository.signUpWithGoogle()).called(1);
    });

    test('saveUserToFirestore calls AuthRepository.saveUserToFirestore',
        () async {
      when(() => mockAuthRepository.saveUserToFirestore(testUser))
          .thenAnswer((_) async => Future.value());

      await authProvider.saveUserToFirestore(testUser);

      verify(() => mockAuthRepository.saveUserToFirestore(testUser)).called(1);
    });

    test('deleteUser calls AuthRepository.deleteUser', () async {
      when(() => mockAuthRepository.deleteUser())
          .thenAnswer((_) async => Future.value());

      await authProvider.deleteUser();

      verify(() => mockAuthRepository.deleteUser()).called(1);
    });

    test('getCurrentUser calls AuthRepository.getCurrentUserFromFirebase',
        () async {
      when(() => mockAuthRepository.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      final result = await authProvider.getCurrentUser();

      expect(result, testUser);
      verify(() => mockAuthRepository.getCurrentUserFromFirebase()).called(1);
    });

    test('setUser calls AuthRepository.setUser', () async {
      when(() => mockAuthRepository.setUser(testUser))
          .thenAnswer((_) async => Future.value());

      await authProvider.setUser(testUser);

      verify(() => mockAuthRepository.setUser(testUser)).called(1);
    });
  });
}
