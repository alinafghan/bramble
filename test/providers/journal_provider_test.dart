import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:journal_app/repositories/journal_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalRepository extends Mock implements JournalRepository {}

void main() {
  late MockJournalRepository mockRepository;
  late JournalProvider provider;
  late Journal testJournal;

  setUp(() {
    mockRepository = MockJournalRepository();
    provider = JournalProvider(repo: mockRepository);
    testJournal = Journal(
      id: '1',
      content: 'Test Body',
      date: '2024-06-12',
      user: Users(userId: '1', email: '', username: '', mod: false),
    );
  });

  group('JournalProvider', () {
    test('getJournal returns Journal from repository', () async {
      when(() => mockRepository.getJournalFromFirebase('1'))
          .thenAnswer((_) async => testJournal);

      final result = await provider.getJournal('1');

      expect(result, equals(testJournal));
      verify(() => mockRepository.getJournalFromFirebase('1')).called(1);
    });

    test('deleteJournal calls repository', () async {
      when(() => mockRepository.deleteJournal('2024-06-12'))
          .thenAnswer((_) async => {});

      await provider.deleteJournal('2024-06-12');

      verify(() => mockRepository.deleteJournal('2024-06-12')).called(1);
    });

    test('setJournal calls repository and returns journal', () async {
      when(() => mockRepository.setJournal(testJournal))
          .thenAnswer((_) async => testJournal);

      final result = await provider.setJournal(testJournal);

      expect(result, equals(testJournal));
      verify(() => mockRepository.setJournal(testJournal)).called(1);
    });

    test('getMonthlyJournal returns a list of journals', () async {
      final date = DateTime(2024, 6);
      final journalList = [testJournal];

      when(() => mockRepository.getMonthlyJournal(date))
          .thenAnswer((_) async => journalList);

      final result = await provider.getMonthlyJournal(date);

      expect(result, equals(journalList));
      verify(() => mockRepository.getMonthlyJournal(date)).called(1);
    });

    test('addImage updates journal with images', () async {
      final updatedJournal = testJournal.copyWith(images: ['img1.png']);

      when(() => mockRepository.addImage(testJournal, ['img1.png']))
          .thenAnswer((_) async => updatedJournal);

      final result = await provider.addImage(testJournal, ['img1.png']);

      expect(result.images, contains('img1.png'));
      verify(() => mockRepository.addImage(testJournal, ['img1.png']))
          .called(1);
    });
  });
}
