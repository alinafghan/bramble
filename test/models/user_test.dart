import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';

void main() {
  group('Users model', () {
    final testBook = Book(
      key: 'b1',
      bookId: 1,
      author: 'Author A',
      title: 'Title A',
      coverUrl: 'http://example.com/cover.jpg',
    );

    final testUser = Users(
      userId: 'user123',
      username: 'testUser',
      email: 'test@example.com',
      profileUrl: 'http://example.com/profile.jpg',
      mod: false,
      savedBooks: [testBook],
    );

    test('toDocument() returns correct map', () {
      final map = testUser.toDocument();
      expect(map['userId'], 'user123');
      expect(map['username'], 'testUser');
      expect(map['email'], 'test@example.com');
      expect(map['mod'], false);
      expect(map['profileUrl'], 'http://example.com/profile.jpg');
      expect((map['savedBooks'] as List).first, testBook.toJson());
    });

    test('fromDocument() creates Users from map', () {
      final doc = {
        'userId': 'user123',
        'username': 'testUser',
        'email': 'test@example.com',
        'mod': false,
        'profileUrl': 'http://example.com/profile.jpg',
        'savedBooks': [testBook.toJson()],
      };

      final user = Users.fromDocument(doc);
      expect(user.userId, 'user123');
      expect(user.username, 'testUser');
      expect(user.email, 'test@example.com');
      expect(user.profileUrl, 'http://example.com/profile.jpg');
      expect(user.mod, false);
      expect(user.savedBooks?.first.title, 'Title A');
    });

    test('copyWith() creates modified copy', () {
      final copy = testUser.copyWith(
        username: 'newUsername',
        email: 'new@example.com',
      );
      expect(copy.username, 'newUsername');
      expect(copy.email, 'new@example.com');
      expect(copy.userId, 'user123'); // unchanged
    });

    test('toString returns correct format', () {
      expect(
        testUser.toString(),
        'userId: user123, username: testUser, email: test@example.com',
      );
    });
  });
}
