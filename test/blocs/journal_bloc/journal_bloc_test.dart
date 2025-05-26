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
  });
}
