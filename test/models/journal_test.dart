import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';

void main() {
  group('Journal Model', () {
    final testUser = Users(
      userId: 'user123',
      username: 'Alina',
      email: 'alina@example.com',
      mod: false,
    );

    final testJournal = Journal(
      id: 'journal001',
      user: testUser,
      date: '2025-06-11',
      content: 'Today I started journaling.',
      images: ['image1.png', 'image2.png'],
    );

    test('toDocument returns correct map', () {
      final map = testJournal.toDocument();

      expect(map['id'], 'journal001');
      expect(map['date'], '2025-06-11');
      expect(map['content'], 'Today I started journaling.');

      // Check list values manually
      expect((map['images'] as List)[0], 'image1.png');
      expect((map['images'] as List)[1], 'image2.png');

      final userMap = map['user'] as Map<String, dynamic>;
      expect(userMap['userId'], 'user123');
      expect(userMap['username'], 'Alina');
      expect(userMap['email'], 'alina@example.com');
      expect(userMap['mod'], false);
    });

    test('fromDocument reconstructs Journal correctly', () {
      final doc = {
        'id': 'journal001',
        'date': '2025-06-11',
        'content': 'Today I started journaling.',
        'images': ['image1.png', 'image2.png'],
        'user': {
          'userId': 'user123',
          'username': 'Alina',
          'email': 'alina@example.com',
          'mod': false,
        },
      };

      final journal = Journal.fromDocument(doc);

      expect(journal.id, 'journal001');
      expect(journal.date, '2025-06-11');
      expect(journal.content, 'Today I started journaling.');
      expect(journal.images?.length, 2);
      expect(journal.images?[0], 'image1.png');
      expect(journal.user.email, 'alina@example.com');
    });

    test('copyWith creates updated Journal', () {
      final updated = testJournal.copyWith(content: 'Updated content');
      expect(updated.content, 'Updated content');
      expect(updated.id, 'journal001');
      expect(updated.user.username, 'Alina');
    });
  });
}
