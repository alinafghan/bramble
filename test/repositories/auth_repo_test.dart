import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journal_app/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/repositories/auth_repository.dart';

// ----- Mocks -----
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockUserCredential extends Mock implements UserCredential {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockGoogleAuthProvider extends Mock implements AuthCredential {}

class MockUserLogin extends Mock implements User {}

class MockAuthRepository extends AuthRepository {
  final Users mockUser;
  final String? mockedEmailFromUsername;

  MockAuthRepository({
    required this.mockUser,
    super.firebaseAuth,
    super.firestore,
    this.mockedEmailFromUsername,
  });

  @override
  Future<Users> getCurrentUserFromFirebase() async {
    return mockUser;
  }

  @override
  Future<String> getEmailFromUsername(String username) async {
    return mockedEmailFromUsername ?? '';
  }
}

void main() {
  // Mocks
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockSnapshot;
  late MockQueryDocumentSnapshot mockDoc;
  late Users testUser;
  late MockDocumentReference mockDocRef;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    registerFallbackValue(FakeAuthCredential());
    mockGoogleSignIn = MockGoogleSignIn();
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockQuery = MockQuery();
    mockSnapshot = MockQuerySnapshot();
    mockDoc = MockQueryDocumentSnapshot();
    mockDocRef = MockDocumentReference();
    testUser = Users(
      userId: 'test123',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
    );
  });

  test('getEmailFromUsername returns email if user found', () async {
    // Arrange Firebase call chain
    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.where('username', isEqualTo: 'testuser'))
        .thenReturn(mockQuery);
    when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);
    when(() => mockSnapshot.docs).thenReturn([mockDoc]);
    when(() => mockDoc.get('email')).thenReturn('test@example.com');

    final repo = AuthRepository(
      firestore: mockFirestore,
      firebaseAuth: mockAuth, // ✅ Prevents real FirebaseAuth.instance usage
    );

    final email = await repo.getEmailFromUsername('testuser');
    expect(email, 'test@example.com');
  });

  test('getEmailFromUsername returns empty string on exception', () async {
    // Arrange: force Firestore to throw an exception
    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.where('username', isEqualTo: 'testuser'))
        .thenReturn(mockQuery);
    when(() => mockQuery.get()).thenThrow(Exception('Firestore error'));

    final repo = AuthRepository(
      firestore: mockFirestore,
      firebaseAuth: mockAuth,
    );
    final email = await repo.getEmailFromUsername('testuser');
    expect(email, '');
  });

  test('saveUserToFirestore stores user with empty savedBooks list', () async {
    // Arrange
    final mockDocRef = MockDocumentReference();

    final user = Users(
      userId: '123',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
      savedBooks: [],
    );

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(user.userId)).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any())).thenAnswer((_) async {});

    final repo = AuthRepository(
      firestore: mockFirestore,
      firebaseAuth: mockAuth,
    );

    await repo.saveUserToFirestore(user);
    final capturedUser = verify(
      () => mockDocRef.set(captureAny()),
    ).captured.single as Map<String, dynamic>;

    expect(capturedUser['savedBooks'], isEmpty);
    expect(capturedUser['email'], equals('test@example.com'));
    expect(capturedUser['userId'], equals('123'));
  });

  test('emailSignUp returns updated user on success', () async {
    final user = Users(
      userId: '',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
    );

    final mockUser = MockUser();
    when(() => mockUser.uid).thenReturn('firebase_uid');

    final mockCredential = MockUserCredential();
    when(() => mockCredential.user).thenReturn(mockUser);

    final mockDocRef = MockDocumentReference();

    when(() => mockAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: 'securepassword',
        )).thenAnswer((_) async => mockCredential);

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any())).thenAnswer((_) async {});

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    final result = await repo.emailSignUp(user, 'securepassword');

    expect(result, isNotNull);
    expect(result!.userId, equals('firebase_uid'));
  });

  test('emailSignUp throws Exception on SocketException', () async {
    final user = Users(
      userId: '',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
    );

    when(() => mockAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: 'securepassword',
        )).thenThrow(const SocketException('No Internet'));

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);

    expect(
      () => repo.emailSignUp(user, 'securepassword'),
      throwsA(predicate((e) =>
          e is Exception && e.toString().contains('No internet connection'))),
    );
  });

  test('emailSignUp returns null on FirebaseAuthException', () async {
    final user = Users(
      userId: '',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
    );

    when(() => mockAuth.createUserWithEmailAndPassword(
              email: user.email,
              password: 'securepassword',
            ))
        .thenThrow(FirebaseAuthException(
            code: 'email-already-in-use', message: 'Email in use'));

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    final result = await repo.emailSignUp(user, 'securepassword');

    expect(result, isNull);
  });

  test('getCurrentUser returns a valid Users object from FirebaseAuth',
      () async {
    final mockFirebaseUser = MockUser();
    when(() => mockFirebaseUser.email).thenReturn('test@example.com');
    when(() => mockFirebaseUser.uid).thenReturn('12345');

    when(() => mockAuth.currentUser).thenReturn(mockFirebaseUser);

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    final user = await repo.getCurrentUser();

    expect(user.email, 'test@example.com');
    expect(user.userId, '12345');
  });
  test('getCurrentUser throws exception on SocketException', () async {
    when(() => mockAuth.currentUser)
        .thenThrow(const SocketException('No connection'));

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);

    expect(
      () async => await repo.getCurrentUser(),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('No internet connection'))),
    );
  });
  test('getCurrentUser throws exception when currentUser is null', () async {
    when(() => mockAuth.currentUser).thenReturn(null);

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);

    expect(
      () async => await repo.getCurrentUser(),
      throwsA(isA<Exception>()
          .having((e) => e.toString(), 'message', contains('User not found'))),
    );
  });

  test('setUser stores user data in Firestore', () async {
    final user = Users(
        userId: '123',
        email: 'test@example.com',
        username: 'testuser',
        mod: false);

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(user.userId))
        .thenReturn(MockDocumentReference());

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    await repo.setUser(user);

    verify(() => mockFirestore.collection('Users')).called(1);
  });

  test('setUser throws exception on SocketException', () async {
    final user = Users(
      userId: '123',
      email: 'test@example.com',
      username: 'testuser',
      mod: false,
    );

    final mockDocRef = MockDocumentReference();

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(user.userId)).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any()))
        .thenThrow(const SocketException('No Internet'));

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);

    expect(
      () async => await repo.setUser(user),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('No internet connection'))),
    );
  });

  test('emailLogin signs in user with email and password', () async {
    final mockCredential = MockUserCredential();
    final mockUser = MockUserLogin();

    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockCredential.user).thenReturn(mockUser);
    when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => mockCredential);

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    final user = await repo.emailLogin('test@example.com', 'password');

    expect(user?.email, 'test@example.com');
  });

  test('emailLogin signs in using username', () async {
    final mockCredential = MockUserCredential();
    final mockUser = MockUserLogin();

    when(() => mockUser.email).thenReturn('resolved@example.com');
    when(() => mockCredential.user).thenReturn(mockUser);

    // Stub FirebaseAuth login
    when(() => mockAuth.signInWithEmailAndPassword(
          email: 'resolved@example.com',
          password: 'password',
        )).thenAnswer((_) async => mockCredential);

    // Use MockAuthRepository and inject resolved email
    final repo = MockAuthRepository(
      mockUser: testUser,
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
      mockedEmailFromUsername: 'resolved@example.com',
    );

    final user = await repo.emailLogin('myusername', 'password');

    expect(user?.email, 'resolved@example.com');
  });

  test('emailLogin returns null if email cannot be resolved from username',
      () async {
    final repo = AuthRepository(
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => repo.getEmailFromUsername('unknown_user'))
        .thenAnswer((_) async => '');

    final user = await repo.emailLogin('unknown_user', 'password');

    expect(user, isNull);
  });

  test('emailLogin throws exception on SocketException', () async {
    final repo = AuthRepository(
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const SocketException('No connection'));

    expect(
      () async => await repo.emailLogin('test@example.com', 'password'),
      throwsA(isA<Exception>()),
    );
  });

  test('emailLogin returns null on FirebaseAuthException', () async {
    final repo = AuthRepository(
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

    final user = await repo.emailLogin('test@example.com', 'password');

    expect(user, isNull);
  });

  test('signOut calls FirebaseAuth.signOut', () async {
    when(() => mockAuth.signOut()).thenAnswer((_) async {});

    final repo =
        AuthRepository(firebaseAuth: mockAuth, firestore: mockFirestore);
    await repo.signOut();

    verify(() => mockAuth.signOut()).called(1);
  });
  test('signOut throws Exception on SocketException', () async {
    when(() => mockAuth.signOut())
        .thenThrow(const SocketException('No internet connection'));

    final repo = AuthRepository(
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    expect(
      () async => await repo.signOut(),
      throwsA(predicate((e) =>
          e is Exception && e.toString().contains('No internet connection'))),
    );
  });

  test('deleteUser successfully deletes user document', () async {
    // Arrange
    final repo = MockAuthRepository(
      mockUser: testUser,
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
    when(() => mockDocRef.delete()).thenAnswer((_) async {});

    // Act
    await repo.deleteUser();

    // Assert
    verify(() => mockFirestore.collection('Users')).called(1);
    verify(() => mockCollection.doc(testUser.userId)).called(1);
    verify(() => mockDocRef.delete()).called(1);
  });

  test('deleteUser throws Exception on SocketException', () async {
    final repo = MockAuthRepository(
      mockUser: testUser,
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
    when(() => mockDocRef.delete())
        .thenThrow(const SocketException('No internet'));

    expect(
      () async => await repo.deleteUser(),
      throwsA(predicate((e) =>
          e is Exception && e.toString().contains('No internet connection'))),
    );
  });

  test('deleteUser logs generic error but does not throw', () async {
    final repo = MockAuthRepository(
      mockUser: testUser,
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );

    when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
    when(() => mockDocRef.delete()).thenThrow(Exception('Unexpected error'));

    // This should not throw (based on your repo code), only logs the error
    await repo.deleteUser();
  });

  group('getCurrentUserFromFirebase', () {
    late AuthRepository repo;

    setUp(() {
      repo = AuthRepository(
        firebaseAuth: mockAuth,
        firestore: mockFirestore,
      );
    });

    test('returns user successfully from Firestore', () async {
      final firebaseUser = MockUser();
      when(() => firebaseUser.email).thenReturn('test@example.com');
      when(() => firebaseUser.uid).thenReturn('12345');
      when(() => mockAuth.currentUser).thenReturn(firebaseUser);

      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.where('email', isEqualTo: 'test@example.com'))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      final testUserMap = {
        'userId': '12345',
        'email': 'test@example.com',
        'username': 'testuser',
        'mod': false,
        'savedBooks': [],
      };

      when(() => mockDoc.data()).thenReturn(testUserMap);

      final user = await repo.getCurrentUserFromFirebase();
      expect(user.email, 'test@example.com');
      expect(user.userId, '12345');
    });

    test('throws Exception when no user found in Firestore', () async {
      final firebaseUser = MockUser();
      when(() => firebaseUser.email).thenReturn('test@example.com');
      when(() => firebaseUser.uid).thenReturn('12345');
      when(() => mockAuth.currentUser).thenReturn(firebaseUser);

      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.where('email', isEqualTo: 'test@example.com'))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([]);

      expect(
        () async => await repo.getCurrentUserFromFirebase(),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('No user found with the given email'))),
      );
    });

    test('throws Exception on SocketException', () async {
      final firebaseUser = MockUser();
      when(() => firebaseUser.email).thenReturn('test@example.com');
      when(() => firebaseUser.uid).thenReturn('12345');
      when(() => mockAuth.currentUser).thenReturn(firebaseUser);

      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.where('email', isEqualTo: 'test@example.com'))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get())
          .thenThrow(const SocketException('No internet connection'));

      expect(
        () async => await repo.getCurrentUserFromFirebase(),
        throwsA(predicate((e) =>
            e is Exception && e.toString().contains('No internet connection'))),
      );
    });

    test('throws Exception on any unexpected error', () async {
      final firebaseUser = MockUser();
      when(() => firebaseUser.email).thenReturn('test@example.com');
      when(() => firebaseUser.uid).thenReturn('12345');
      when(() => mockAuth.currentUser).thenReturn(firebaseUser);

      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.where('email', isEqualTo: 'test@example.com'))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenThrow(Exception('Firestore broken'));

      expect(
        () async => await repo.getCurrentUserFromFirebase(),
        throwsA(predicate((e) =>
            e is Exception && e.toString().contains('Failed to fetch user'))),
      );
    });
  });
  group('addProfilePic', () {
    late MockAuthRepository mockAuthRepo;

    setUp(() {
      mockAuthRepo = MockAuthRepository(
        mockUser: testUser,
        firebaseAuth: mockAuth,
        firestore: mockFirestore,
      );
    });

    test('returns updated user on successful update', () async {
      // Arrange
      const testProfileUrl = 'https://example.com/pic.jpg';
      final updatedUserData = {
        'userId': testUser.userId,
        'email': testUser.email,
        'username': testUser.username,
        'mod': testUser.mod,
        'profileUrl': testProfileUrl,
      };

      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.update({'profileUrl': testProfileUrl}))
          .thenAnswer((_) async {});
      when(() => mockDocRef.get()).thenAnswer((_) async {
        final mockSnapshot = MockQueryDocumentSnapshot();
        when(() => mockSnapshot.data()).thenReturn(updatedUserData);
        return mockSnapshot;
      });

      // Act
      final result = await mockAuthRepo.addProfilePic(testProfileUrl);

      // Assert
      expect(result?.userId, testUser.userId);
      expect(result?.profileUrl, testProfileUrl);
    });

    test('throws exception on SocketException', () async {
      // Arrange
      when(() => mockFirestore.collection('Users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any()))
          .thenThrow(const SocketException('Failed to connect'));

      // Act & Assert
      expect(
        () async => await mockAuthRepo.addProfilePic('https://example.com'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No internet connection'),
          ),
        ),
      );
    });

    test('throws exception on generic error', () async {
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any()))
          .thenThrow(FirebaseException(plugin: 'firestore', message: 'fail'));

      expect(
        () async => await mockAuthRepo.addProfilePic('https://example.com'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message',
            contains('Failed to update profile picture'))),
      );
    });
  });

  group('signUpWithGoogle', () {
    test('returns UserCredential on success', () async {
      final mockGoogleUser = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockCredential = MockUserCredential();

      final testCredential = GoogleAuthProvider.credential(
        idToken: 'id_token',
        accessToken: 'access_token',
      );

      when(() => mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleUser);
      when(() => mockGoogleUser.authentication)
          .thenAnswer((_) async => mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('id_token');
      when(() => mockGoogleAuth.accessToken).thenReturn('access_token');
      when(() => mockAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockCredential);

      final repoWithGoogle = AuthRepository(
        firebaseAuth: mockAuth,
        firestore: mockFirestore,
        googleSignIn: mockGoogleSignIn,
      );

      final result = await repoWithGoogle.signUpWithGoogle();

      expect(result, mockCredential);
    });

    test('throws Exception if Google sign-in fails', () async {
      when(() => mockGoogleSignIn.signIn())
          .thenThrow(Exception('Google sign-in failed'));
      when(() => mockAuth.signInWithCredential(any()))
          .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      final failingRepo = AuthRepository(
        firebaseAuth: mockAuth,
        firestore: mockFirestore,
        googleSignIn: mockGoogleSignIn,
      );

      // Since GoogleSignIn is a static call inside the method, to test a true fail,
      // you'd have to inject GoogleSignIn. But we can test error handling logic still.
      expect(() => failingRepo.signUpWithGoogle(), throwsException);
    });
  });
}
