import 'dart:io';

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
  late MockAuthRepository mockAuthRepo;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockReviewCollection;
  late MockCollectionReference mockLikeCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocSnapshot;
  late Users testUser;
  late Book testBook;
  late Review testReview;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockFirestore = MockFirebaseFirestore();
    mockReviewCollection = MockCollectionReference();
    mockLikeCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocSnapshot = MockQueryDocumentSnapshot();

    reviewRepo = ReviewRepository(repo: mockAuthRepo, firestore: mockFirestore);

    when(() => mockFirestore.collection('Reviews'))
        .thenReturn(mockReviewCollection);
    when(() => mockFirestore.collection('Likes'))
        .thenReturn(mockLikeCollection);

    testUser =
        Users(userId: 'user123', username: 'testuser', email: '', mod: false);
    testBook = Book(bookId: 1, key: '', author: '', title: '');
    testReview = Review(
        book: testBook,
        user: testUser,
        text: 'Great book!',
        numLikes: 0,
        id: '',
        createdAt: '');
  });

  group('setReview', () {
    test('returns Review when successful', () async {
      when(() => mockAuthRepo.getCurrentUser())
          .thenAnswer((_) async => testUser);
      when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any())).thenAnswer((_) async => {});

      final result = await reviewRepo.setReview(testReview, testBook);

      expect(result, isA<Review>());
      expect(result.id, testUser.userId + testBook.bookId.toString());
    });

    test('throws SocketException when no WiFi', () async {
      when(() => mockAuthRepo.getCurrentUser())
          .thenThrow(const SocketException('No internet'));

      expect(
        () async => await reviewRepo.setReview(testReview, testBook),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getReview', () {
    test('returns Review if document exists', () async {
      when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testReview.toDocument());

      final result = await reviewRepo.getReview(testBook, 'user123');
      expect(result, isA<Review>());
    });

    test('returns null if document does not exist', () async {
      when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.exists).thenReturn(false);

      final result = await reviewRepo.getReview(testBook, 'user123');
      expect(result, null);
    });

    test('throws SocketException', () async {
      when(() => mockReviewCollection.doc(any()))
          .thenThrow(const SocketException('No connection'));

      expect(
        () async => await reviewRepo.getReview(testBook, 'user123'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getReviewsForBook', () {
    test('returns list of reviews and sets like status', () async {
      when(() => mockReviewCollection.where("book.bookId", isEqualTo: 1))
          .thenReturn(mockReviewCollection);
      when(() => mockReviewCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

      when(() => mockQueryDocSnapshot.data())
          .thenReturn(testReview.toDocument());

      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockLikeCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.exists).thenReturn(true);

      final results = await reviewRepo.getReviewsForBook(testBook);

      expect(results.length, 1);
      expect(results[0].isLikedByCurrentUser, true);
    });

    test('throws SocketException', () async {
      when(() => mockReviewCollection.where("book.bookId", isEqualTo: 1))
          .thenThrow(const SocketException('No internet'));

      expect(
        () async => await reviewRepo.getReviewsForBook(testBook),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('likeReview', () {
    test('likes a review if not liked', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockLikeCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.exists).thenReturn(false);
      when(() => mockDocRef.set(any())).thenAnswer((_) async => {});
      when(() => mockFirestore.collection('Reviews'))
          .thenReturn(mockReviewCollection);
      when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => {});

      final result = await reviewRepo.likeReview(testReview);
      expect(result.numLikes, 1);
    });

    test('unlikes a review if already liked', () async {
      testReview.numLikes = 1;
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockLikeCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocRef.delete()).thenAnswer((_) async => {});
      when(() => mockFirestore.collection('Reviews'))
          .thenReturn(mockReviewCollection);
      when(() => mockReviewCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => {});

      final result = await reviewRepo.likeReview(testReview);
      expect(result.numLikes, 0);
    });

    test('throws SocketException', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(const SocketException('No internet'));

      expect(() async => await reviewRepo.likeReview(testReview),
          throwsA(isA<Exception>()));
    });
  });
}
