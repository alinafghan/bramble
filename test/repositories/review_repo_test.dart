import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/repositories/review_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ReviewRepository reviewRepo;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockReviewCollection;
  late MockCollectionReference mockLikeCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnap;
  late MockAuthRepository mockAuthRepo;
  late Users testUser;
  late Book testBook;
  late Review testReview;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockReviewCollection = MockCollectionReference();
    mockLikeCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnap = MockDocumentSnapshot();
    mockAuthRepo = MockAuthRepository();

    reviewRepo = ReviewRepository(repo: mockAuthRepo, firestore: mockFirestore);

    testUser = Users(
        username: 'testuser',
        userId: 'u123',
        email: 'test@email.com',
        mod: false);
    testBook =
        Book(title: 'Sample Book', author: 'Author', bookId: 123, key: '1');
    testReview = Review(
        user: testUser,
        book: testBook,
        numLikes: 0,
        text: '',
        id: '',
        createdAt: '');

    when(() => mockFirestore.collection('Reviews'))
        .thenReturn(mockReviewCollection);
    when(() => mockFirestore.collection('Likes'))
        .thenReturn(mockLikeCollection);
  });

  test('setReview throws Exception on generic error', () async {
    when(() => mockAuthRepo.getCurrentUser()).thenAnswer((_) async => testUser);
    when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any())).thenThrow(Exception('Generic error'));

    expect(
      () async => await reviewRepo.setReview(testReview, testBook),
      throwsA(isA<Exception>()),
    );
  });

  test('getReview returns null when doc does not exist', () async {
    when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenAnswer((_) async {
      when(() => mockDocSnap.exists).thenReturn(false);
      return mockDocSnap;
    });

    final result = await reviewRepo.getReview(testBook, 'u123');
    expect(result, isNull);
  });

  test('getReview throws Exception on generic error', () async {
    when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenThrow(Exception('Generic error'));

    expect(
      () async => await reviewRepo.getReview(testBook, 'u123'),
      throwsA(isA<Exception>()),
    );
  });

  test('likeReview throws Exception on generic error', () async {
    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockLikeCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenThrow(Exception('Generic error'));

    expect(
      () async => await reviewRepo.likeReview(testReview),
      throwsA(isA<Exception>()),
    );
  });
}
