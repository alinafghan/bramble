import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/repositories/book_list_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock implements CollectionReference {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock implements DocumentReference {}

// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockDocumentSnapshot mockSnapshot;
  late BookListRepository bookListRepo;
  late Users testUser;
  late Book testBook;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    testBook = Book(title: 'Test Book', author: 'Author', key: '', bookId: 1);
    testUser = Users(userId: 'uid123', savedBooks: [], email: '', mod: false);

    bookListRepo = BookListRepository(
      repo: mockAuthRepo,
      usersCollection: mockCollection,
    );
  });

  group('returnBookList', () {
    test('returns list of saved books', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn(testUser.toDocument());

      final books = await bookListRepo.returnBookList();

      expect(books, testUser.savedBooks);
    });

    test('throws Exception on SocketException', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(const SocketException('no connection'));

      expect(() => bookListRepo.returnBookList(), throwsException);
    });

    test('throws generic Exception on unknown error', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(Exception('Unexpected error'));

      expect(() => bookListRepo.returnBookList(), throwsException);
    });
  });

  group('saveBook', () {
    test('adds a new book and updates Firestore', () async {
      testUser.savedBooks = [];
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDoc);
      when(() => mockDoc.update(any())).thenAnswer((_) async => {});

      print(
          'savedBooks contains testBook? ${testUser.savedBooks!.contains(testBook)}');
      await bookListRepo.saveBook(testBook);

      verify(() => mockDoc.update(any())).called(1);
      expect(testUser.savedBooks!.contains(testBook), isTrue);
    });

    test('does not add duplicate books', () async {
      testUser.savedBooks = [testBook];
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      await bookListRepo.saveBook(testBook);

      verifyNever(() => mockDoc.update(any()));
    });

    test('throws Exception on SocketException', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(const SocketException('no connection'));

      expect(() => bookListRepo.saveBook(testBook), throwsException);
    });

    test('throws generic Exception on unknown error', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(Exception('something went wrong'));

      expect(() => bookListRepo.saveBook(testBook), throwsException);
    });
  });

  group('removeBook', () {
    test('removes a book and updates Firestore', () async {
      testUser.savedBooks = [testBook];
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockCollection.doc(testUser.userId)).thenReturn(mockDoc);
      when(() => mockDoc.update(any())).thenAnswer((_) async => {});

      await bookListRepo.removeBook(testBook);

      verify(() => mockDoc.update(any())).called(1);
      expect(testUser.savedBooks!.contains(testBook), isFalse);
    });

    test('throws Exception on SocketException', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(const SocketException('no connection'));

      expect(() => bookListRepo.removeBook(testBook), throwsException);
    });

    test('throws generic Exception on unknown error', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenThrow(Exception('Unexpected'));

      expect(() => bookListRepo.removeBook(testBook), throwsException);
    });
  });
}
