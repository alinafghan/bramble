import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';

void main() {
  final mockUser = Users(
    userId: 'u1',
    username: 'Alina',
    email: 'alina@example.com',
    mod: false,
  );

  final mockJournal = Journal(
    id: 'j1',
    user: mockUser,
    date: '2025-06-11',
    content: 'Journal content',
    images: ['image1.png', 'image2.png'],
  );

  group('JournalEvent props tests', () {
    test('SetJournal props', () {
      final event = SetJournal(journal: mockJournal);
      expect(event.props, [mockJournal]);
    });

    test('AddImage props', () {
      final event = AddImage(journal: mockJournal, image: ['img1.png']);
      expect(event.props, [
        ['img1.png']
      ]);
    });

    test('DeleteJournal props', () {
      const event = DeleteJournal(date: '2025-06-11');
      expect(event.props, ['2025-06-11']);
    });

    test('GetJournal props', () {
      const event = GetJournal(id: 'j1');
      expect(event.props, ['j1']);
    });

    test('GetMonthlyJournal props', () {
      final date = DateTime(2025, 6, 1);
      final event = GetMonthlyJournal(month: date);
      expect(event.props, [date]);
    });
  });
}
