import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockJournalProvider extends Mock implements JournalProvider {}

void main() {
  group('journal bloc', () {
    final mockProvider = MockJournalProvider();
    final journal = Journal(
        id: '123',
        date: '2023-10-01',
        content: 'Test content',
        user: Users(userId: 'user123', email: 'user@gmail.com'));

    blocTest<JournalBloc, JournalState>(
      'handles getjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getJournal('123'))
            .thenAnswer((_) async => journal);
      },
      act: (bloc) => bloc.add(const GetJournal(id: '123')),
      skip: 1, //skip loading
      expect: () => <JournalState>[GetJournalSuccess(journal: journal)],
    );
    blocTest<JournalBloc, JournalState>(
      'fails on getjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getJournal('123'))
            .thenAnswer((_) async => throw Exception('Failed to get journal'));
      },
      act: (bloc) => bloc.add(const GetJournal(id: '123')),
      skip: 1, //skip loading
      expect: () => <JournalState>[GetJournalFailure()],
    );
    blocTest<JournalBloc, JournalState>(
      'handles setjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.setJournal(journal))
            .thenAnswer((_) async => journal);
      },
      act: (bloc) => bloc.add(SetJournal(journal: journal)),
      skip: 1, //skip loading
      expect: () => <JournalState>[SetJournalSuccess(journal: journal)],
    );
    blocTest<JournalBloc, JournalState>(
      'fails on setjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.setJournal(journal))
            .thenAnswer((_) async => throw Exception('Failed to set journal'));
      },
      act: (bloc) => bloc.add(SetJournal(journal: journal)),
      skip: 1, //skip loading
      expect: () => <JournalState>[SetJournalFailure()],
    );
    blocTest<JournalBloc, JournalState>(
      'handles deletejournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.deleteJournal('2023-10-01'))
            .thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(const DeleteJournal(date: '2023-10-01')),
      skip: 1, //skip loading
      expect: () => <JournalState>[DeleteJournalSuccess()],
    );
    blocTest<JournalBloc, JournalState>(
      'fails on deletejournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.deleteJournal('2023-10-01')).thenAnswer(
            (_) async => throw Exception('Failed to delete journal'));
      },
      act: (bloc) => bloc.add(const DeleteJournal(date: '2023-10-01')),
      skip: 1, //skip loading
      expect: () => <JournalState>[DeleteJournalFailure()],
    );
    blocTest<JournalBloc, JournalState>(
      'handles getmonthlyjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getMonthlyJournal(DateTime(2023, 10, 1)))
            .thenAnswer((_) async => [journal]);
      },
      act: (bloc) => bloc.add(GetMonthlyJournal(month: DateTime(2023, 10, 1))),
      skip: 1, //skip loading
      expect: () => <JournalState>[
        GetMonthlyJournalSuccess(journals: [journal])
      ],
    );
    blocTest<JournalBloc, JournalState>(
      'fails on getmonthlyjournal successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getMonthlyJournal(DateTime.now())).thenAnswer(
            (_) async => throw Exception('Failed to get monthly journal'));
      },
      act: (bloc) => bloc.add(GetMonthlyJournal(month: DateTime.now())),
      skip: 1, //skip loading
      expect: () => <JournalState>[GetMonthlyJournalError()],
    );
    blocTest<JournalBloc, JournalState>(
      'handles addimage successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.addImage(journal, ['image_path']))
            .thenAnswer((_) async => journal);
      },
      act: (bloc) =>
          bloc.add(AddImage(journal: journal, image: const ['image_path'])),
      skip: 1, //skip loading
      expect: () => <JournalState>[SetJournalSuccess(journal: journal)],
    );
    blocTest<JournalBloc, JournalState>(
      'fails on addimage successfully',
      build: () => JournalBloc(journalProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.addImage(journal, ['image_path']))
            .thenAnswer((_) async => throw Exception('Failed to add image'));
      },
      act: (bloc) =>
          bloc.add(AddImage(journal: journal, image: const ['image_path'])),
      skip: 1, //skip loading
      expect: () => <JournalState>[SetJournalFailure()],
    );
  });
}
