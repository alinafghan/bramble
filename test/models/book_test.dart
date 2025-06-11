import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';

void main() {
  group('Book model', () {
    final baseBook = Book(
      key: 'abc123',
      bookId: 42,
      author: 'George Orwell',
      title: '1984',
      coverUrl: 'https://covers.openlibrary.org/b/id/42-L.jpg',
      description: 'A dystopian novel',
      excerpt: 'It was a bright cold day in April...',
      publishYear: '1949',
    );

    test('supports value comparison', () {
      final book2 = Book(
        key: 'abc123',
        bookId: 42,
        author: 'George Orwell',
        title: '1984',
        coverUrl: 'https://covers.openlibrary.org/b/id/42-L.jpg',
      );
      expect(baseBook, equals(book2));
    });

    test('toJson returns correct map', () {
      expect(baseBook.toJson(), {
        'key': 'abc123',
        'bookId': 42,
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://covers.openlibrary.org/b/id/42-L.jpg',
      });
    });

    test('fromJson parses API format correctly', () {
      final json = {
        'key': 'abc123',
        'cover_id': 42,
        'title': '1984',
        'authors': [
          {'name': 'George Orwell'}
        ],
      };
      final result = Book.fromJson(json);
      expect(result.key, 'abc123');
      expect(result.bookId, 42);
      expect(result.title, '1984');
      expect(result.author, 'George Orwell');
    });

    test('fromSearch parses search response correctly', () {
      final json = {
        'key': 'abc123',
        'cover_i': 42,
        'title': '1984',
        'author_name': ['George Orwell'],
        'first_publish_year': 1949,
      };
      final result = Book.fromSearch(json);
      expect(result.bookId, 42);
      expect(result.coverUrl, 'https://covers.openlibrary.org/b/id/42-L.jpg');
      expect(result.publishYear, '1949');
    });

    test('fromSearch uses fallback coverUrl and publishYear if missing', () {
      final json = {
        'key': 'abc123',
        'title': '1984',
        'author_name': ['George Orwell'],
      };
      final result = Book.fromSearch(json);
      expect(result.coverUrl, contains('iarc.fr'));
      expect(result.publishYear, 'No date provided');
    });

    test('fromFirebase parses Firebase format correctly', () {
      final json = {
        'key': 'abc123',
        'bookId': 42,
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://example.com/cover.jpg',
      };
      final result = Book.fromFirebase(json);
      expect(result.title, '1984');
      expect(result.author, 'George Orwell');
      expect(result.coverUrl, 'https://example.com/cover.jpg');
    });

    test('addJson merges additional data correctly', () {
      final json = {
        'description': {'value': 'A dystopian novel'},
        'excerpts': [
          {'excerpt': 'It was a bright cold day in April...'}
        ],
        'first_publish_date': '1949',
      };
      final result = Book.addJson(baseBook, json);
      expect(result.description, 'A dystopian novel');
      expect(result.excerpt, 'It was a bright cold day in April...');
      expect(result.publishYear, '1949');
    });

    test('addJson falls back when fields are missing or malformed', () {
      final json = {
        'description': null,
        'first_sentence': {'value': 'Fallback excerpt'},
      };
      final result = Book.addJson(baseBook, json);
      expect(result.description, 'No description available.');
      expect(result.excerpt, 'Fallback excerpt');
    });
  });
}
