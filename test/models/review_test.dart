import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/models/review.dart';

void main() {
  group('Review model', () {
    final testBook = Book(
      key: 'bk123',
      bookId: 101,
      author: 'Test Author',
      title: 'Test Title',
    );

    final testUser = Users(
      userId: 'u123',
      username: 'testuser',
      email: 'test@example.com',
      mod: false,
      profileUrl: 'http://example.com/user.jpg',
    );

    final testReview = Review(
      id: 'r001',
      user: testUser,
      book: testBook,
      text: 'Great read!',
      createdAt: '2023-06-01',
      numLikes: 5,
    );

    test('toDocument returns correct map', () {
      final doc = testReview.toDocument();
      expect(doc['id'], 'r001');
      expect(doc['text'], 'Great read!');
      expect(doc['createdAt'], '2023-06-01');
      expect(doc['numLikes'], 5);
      expect((doc['user'] as Map)['userId'], 'u123');
      expect((doc['book'] as Map)['title'], 'Test Title');
    });

    test('fromDocument reconstructs Review correctly', () {
      final mockDoc = {
        'id': 'r001',
        'text': 'Great read!',
        'createdAt': '2023-06-01',
        'numLikes': 5,
        'user': {
          'userId': 'u123',
          'username': 'testuser',
          'email': 'test@example.com',
          'profileUrl': 'http://example.com/user.jpg',
          'mod': false,
        },
        'book': {
          'key': 'bk123',
          'bookId': 101,
          'author': 'Test Author',
          'title': 'Test Title',
        },
      };

      final review = Review.fromDocument(mockDoc);
      expect(review.id, 'r001');
      expect(review.text, 'Great read!');
      expect(review.createdAt, '2023-06-01');
      expect(review.numLikes, 5);
      expect(review.user.userId, 'u123');
      expect(review.book.title, 'Test Title');
    });
  });
}
