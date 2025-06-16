import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/repositories/journal_repository.dart';
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
  late JournalRepository journalRepo;
  late MockCollectionReference mockCollection;
  late MockAuthRepository mockAuthRepo;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockSnapshot;
  late Users testUser;
  late Journal testJournal;

  setUp(() {
    mockCollection = MockCollectionReference();
    mockAuthRepo = MockAuthRepository();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockDocRef = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    when(() => mockFirebaseFirestore.collection('Journal'))
        .thenReturn(mockCollection);

    journalRepo = JournalRepository(
      repo: mockAuthRepo,
      firestore: mockFirebaseFirestore,
    );

    testUser = Users(
        userId: 'user123',
        username: 'user123',
        email: 'test@example.com',
        mod: false);
    testJournal = Journal(
        id: 'user1232023-06-01',
        date: '2023-06-01',
        content: 'Test entry',
        user: testUser);
  });

  group('getJournalFromFirebase', () {
    test('returns Journal if doc exists', () async {
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(testJournal.toDocument());
      final mockData = testJournal.toDocument();
      when(() => mockSnapshot.data()).thenReturn(mockData);

      final result = await journalRepo.getJournalFromFirebase(testJournal.id);
      expect(result, isA<Journal>());
    });

    test('returns null if doc does not exist', () async {
      final mockDocRef = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      final result = await journalRepo.getJournalFromFirebase(testJournal.id);
      expect(result, isNull);
    });

    test('throws Exception on SocketException', () async {
      final mockDocRef = MockDocumentReference();
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get())
          .thenThrow(const SocketException('No connection'));

      expect(() => journalRepo.getJournalFromFirebase(testJournal.id),
          throwsException);
    });

    test('throws generic Exception on unexpected error', () async {
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);

      // Simulate Firebase throwing a generic exception
      when(() => mockDocRef.get()).thenThrow(Exception('Unexpected error'));

      expect(
        () => journalRepo.getJournalFromFirebase(testJournal.id),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'description', contains('Unexpected error'))),
      );
    });
  });

  group('getMonthlyJournal', () {
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockQueryDocSnapshot;
    late DateTime testMonth;

    setUp(() {
      mockQuerySnapshot = MockQuerySnapshot();
      mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      testMonth = DateTime(2023, 6);
    });

    test('returns a list of journals for given month', () async {
      // Mock current user
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      // Mock Firestore query
      when(() => mockCollection.where('date',
              isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('date',
              isLessThanOrEqualTo: any(named: 'isLessThanOrEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('user.userId',
          isEqualTo: any(named: 'isEqualTo'))).thenReturn(mockCollection);
      when(() => mockCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data())
          .thenReturn(testJournal.toDocument());

      final result = await journalRepo.getMonthlyJournal(testMonth);
      expect(result, isA<List<Journal>>());
      expect(result.length, 1);
      expect(result.first.content, equals('Test entry'));
    });

    test('returns empty list when no journals found', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      when(() => mockCollection.where('date',
              isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('date',
              isLessThanOrEqualTo: any(named: 'isLessThanOrEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('user.userId',
          isEqualTo: any(named: 'isEqualTo'))).thenReturn(mockCollection);
      when(() => mockCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await journalRepo.getMonthlyJournal(testMonth);
      expect(result, isEmpty);
    });

    test('throws generic exception when an unexpected error occurs', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      when(() => mockCollection.where('date',
              isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
          .thenThrow(Exception('Something went wrong'));

      expect(
          () => journalRepo.getMonthlyJournal(testMonth),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'desc', contains('Something went wrong'))));
    });

    test('throws exception on SocketException', () async {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      when(() => mockCollection.where('date',
              isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
          .thenThrow(const SocketException('No Internet'));

      expect(
        () => journalRepo.getMonthlyJournal(testMonth),
        throwsA(isA<SocketException>()),
      );
    });
  });

  group('deleteJournal', () {
    const testDate = '2023-06-01';
    final testUser =
        Users(userId: 'user123', email: 'test@example.com', mod: false);
    final journalId = testUser.userId + testDate;

    setUp(() {
      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockCollection.doc(journalId)).thenReturn(mockDocRef);
    });

    test('successfully deletes journal', () async {
      when(() => mockDocRef.delete()).thenAnswer((_) async {});

      await journalRepo.deleteJournal(testDate);

      verify(() => mockDocRef.delete()).called(1);
    });

    test('throws Exception on SocketException', () async {
      when(() => mockDocRef.delete())
          .thenThrow(const SocketException('No internet'));

      expect(
        () => journalRepo.deleteJournal(testDate),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'desc',
            contains('No internet connection'),
          ),
        ),
      );
    });

    test('rethrows any other exception', () async {
      final error = Exception('Some unexpected error');
      when(() => mockDocRef.delete()).thenThrow(error);

      expect(
        () => journalRepo.deleteJournal(testDate),
        throwsA(error),
      );
    });
  });

  group('setJournal', () {
    final testUser =
        Users(userId: 'user123', email: 'test@example.com', mod: false);
    late Journal testJournal;

    setUp(() {
      testJournal = Journal(
        id: '1',
        date: '2023-06-01',
        content: 'Test content',
        images: ['img1.png'],
        user: testUser,
      );

      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);

      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    });

    test('creates a new journal if it does not exist', () async {
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);
      when(() => mockDocRef.set(any())).thenAnswer((_) async {});

      final result = await journalRepo.setJournal(testJournal);

      verify(() => mockDocRef.set(testJournal.toDocument())).called(1);
      expect(result.id, equals(testUser.userId + testJournal.date));
    });

    test('updates existing journal if doc exists', () async {
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      final result = await journalRepo.setJournal(testJournal);

      verify(() => mockDocRef.update({
            'content': testJournal.content,
            'images': testJournal.images,
          })).called(1);

      expect(result.id, equals(testUser.userId + testJournal.date));
    });

    test('throws Exception on SocketException', () async {
      when(() => mockCollection.doc(any()))
          .thenThrow(const SocketException('No internet'));

      expect(
        () => journalRepo.setJournal(testJournal),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'desc',
            contains('No internet connection'),
          ),
        ),
      );
    });

    test('rethrows any other exception', () async {
      final error = Exception('Some error');
      when(() => mockDocRef.get()).thenThrow(error);

      expect(() => journalRepo.setJournal(testJournal), throwsA(error));
    });
  });

  group('addImage', () {
    final testUser =
        Users(userId: 'user123', email: 'test@example.com', mod: false);
    late Journal testJournal;
    final newImages = ['new_image_1.png', 'new_image_2.png'];

    setUp(() {
      testJournal = Journal(
        id: '1',
        date: '2023-06-01',
        content: 'Test content',
        images: ['existing_image.png'],
        user: testUser,
      );

      when(() => mockAuthRepo.getCurrentUserFromFirebase())
          .thenAnswer((_) async => testUser);
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    });

    test('updates journal if document exists', () async {
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      final result = await journalRepo.addImage(testJournal, newImages);

      expect(result.images, containsAll(['existing_image.png', ...newImages]));
      verify(() => mockDocRef.update(testJournal.toDocument())).called(1);
    });

    test('creates journal if document does not exist', () async {
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);
      when(() => mockDocRef.set(any())).thenAnswer((_) async {});

      final result = await journalRepo.addImage(testJournal, newImages);

      expect(result.images, containsAll(['existing_image.png', ...newImages]));
      verify(() => mockDocRef.set(testJournal.toDocument())).called(1);
    });

    test('throws Exception on SocketException', () async {
      when(() => mockCollection.doc(any()))
          .thenThrow(const SocketException('No Internet'));

      expect(
        () => journalRepo.addImage(testJournal, newImages),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'desc',
            contains('No internet connection'),
          ),
        ),
      );
    });

    test('rethrows any other exception', () async {
      final error = Exception('Unexpected error');
      when(() => mockDocRef.get()).thenThrow(error);

      expect(
          () => journalRepo.addImage(testJournal, newImages), throwsA(error));
    });
  });
}
