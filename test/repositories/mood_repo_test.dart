import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/repositories/mood_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MoodRepository moodRepo;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockAuthRepository mockAuthRepo;
  late Users testUser;
  late Mood testMood;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockAuthRepo = MockAuthRepository();

    when(() => mockFirestore.collection('Moods')).thenReturn(mockCollection);

    testUser = Users(
        userId: 'u1', email: 'test@mail.com', username: 'tester', mod: false);
    testMood = Mood(date: '2025-06-12', mood: 'happy.png', user: testUser);

    moodRepo = MoodRepository(repo: mockAuthRepo, firestore: mockFirestore);
  });

  test('setMood stores mood and returns it', () async {
    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any())).thenAnswer((_) async => Future.value());

    final mood = await moodRepo.setMood('happy.png', '2025-06-12');

    expect(mood.date, '2025-06-12');
    expect(mood.mood, 'happy.png');
    expect(mood.user.userId, testUser.userId);
  });

  test('deleteMood deletes document', () async {
    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.delete()).thenAnswer((_) async => Future.value());

    await moodRepo.deleteMood('2025-06-12');

    verify(() => mockDocRef.delete()).called(1);
  });

  test('deleteMood throws Exception when firestore delete fails', () async {
    const date = '2024-06-12';

    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);

    when(() => mockCollection.doc(date + testUser.userId))
        .thenReturn(mockDocRef);

    when(() => mockDocRef.delete())
        .thenThrow(Exception('Firestore delete failed'));

    expect(
      () async => await moodRepo.deleteMood(date),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Error deleting mood'))),
    );
  });

  test('getMood returns moods for given month', () async {
    final mockQuery = MockQuery();
    final mockSnapshot = MockQuerySnapshot();
    final mockDoc = MockQueryDocumentSnapshot();

    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockCollection.where('date',
            isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
        .thenReturn(mockQuery);
    when(() => mockQuery.where('date',
            isLessThanOrEqualTo: any(named: 'isLessThanOrEqualTo')))
        .thenReturn(mockQuery);
    when(() =>
            mockQuery.where('user.userId', isEqualTo: any(named: 'isEqualTo')))
        .thenReturn(mockQuery);
    when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);
    when(() => mockSnapshot.docs).thenReturn([mockDoc]);
    when(() => mockDoc.data()).thenReturn(testMood.toJson());

    final result = await moodRepo.getMood(DateTime(2025, 6));

    expect(result, isNotNull);
    expect(result!.containsKey('2025-06-12'), isTrue);
    expect(result['2025-06-12']!.mood, 'happy.png');
  });

  test('setMood throws on error', () async {
    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.set(any())).thenThrow(Exception('error'));

    expect(() => moodRepo.setMood('angry.png', '2025-06-12'), throwsException);
  });

  test('getMood throws on error', () async {
    when(() => mockAuthRepo.getCurrentUserFromFirebase())
        .thenAnswer((_) async => testUser);
    when(() => mockCollection.where(any(),
            isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo')))
        .thenThrow(Exception('Query error'));

    expect(() => moodRepo.getMood(DateTime(2025, 6)), throwsException);
  });
}
