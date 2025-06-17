import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/repositories/library_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('LibraryRepository', () {
    test('getLibrary returns books on success', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({
              'works': [
                {
                  'title': 'Test Book',
                  'key': '/works/OL123W',
                  'cover_id': 123,
                  'authors': [
                    {'name': 'Author A'}
                  ],
                }
              ]
            }),
            200);
      });

      final repository = LibraryRepository(client: client);
      final books = await repository.getLibrary();

      expect(books, isA<List<Book>>());
      expect(books.length, 1);
      expect(books[0].title, 'Test Book');
    });

    test('getLibrary throws on SocketException', () async {
      final client = MockClient((request) async {
        throw const SocketException('No internet');
      });

      final repository = LibraryRepository(client: client);

      expect(() => repository.getLibrary(), throwsA(isA<Exception>()));
    });

    test('getLibrary throws on generic exception', () async {
      // MockClient returns a 200 response with invalid JSON to trigger a decode exception
      final client = MockClient((request) async {
        return http.Response(
            'Invalid JSON', 200); // this will break json.decode
      });

      final repository = LibraryRepository(client: client);

      expect(
        () => repository.getLibrary(),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('error getting books from api'))),
      );
    });

    test('searchBook returns books on success', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({
              'docs': [
                {
                  'title': 'Search Result',
                  'key': '/works/OL456W',
                  'cover_i': 456,
                  'author_name': ['Author B'],
                }
              ]
            }),
            200);
      });

      final repository = LibraryRepository(client: client);
      final books = await repository.searchBook("query");

      expect(books, isA<List<Book>>());
      expect(books.length, 1);
      expect(books[0].title, 'Search Result');
    });

    test('searchBook rethrows on SocketException', () async {
      final client = MockClient((request) async {
        throw const SocketException('No internet');
      });

      final repository = LibraryRepository(client: client);

      expect(
        () => repository.searchBook('test'),
        throwsA(isA<SocketException>()
            .having((e) => e.message, 'message', contains('No internet'))),
      );
    });

    test('searchBook throws on generic exception', () async {
      final client = MockClient((request) async {
        return http.Response('Invalid JSON', 200); // force decode error
      });

      final repository = LibraryRepository(client: client);

      expect(
        () => repository.searchBook('test'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains(
                'There has been a server error while searching for books'))),
      );
    });

    test('getBookDetails adds data to book', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({'description': 'This is a test'}), 200);
      });

      final repo = LibraryRepository(client: client);
      final book = Book(
          title: 'Detail Book',
          key: '/works/OL999W',
          author: 'austen',
          bookId: 1);
      final result = await repo.getBookDetails(book);

      expect(result, isA<Book>());
      expect(result.title, 'Detail Book');
    });

    test('getBookDetails throws on SocketException', () async {
      final client = MockClient((request) async {
        throw const SocketException('No internet');
      });

      final repository = LibraryRepository(client: client);

      final book = Book(
        bookId: 123,
        title: 'Fake Title',
        author: 'Fake Author',
        key: '/works/FAKE_KEY',
        coverUrl: '',
      );

      expect(
          () => repository.getBookDetails(book),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString().contains('No internet connection'))));
    });
    test('getBookDetails throws generic exception on unexpected error',
        () async {
      final client = MockClient((request) async {
        throw Exception('Something went wrong');
      });

      final repository = LibraryRepository(client: client);

      final book = Book(
        bookId: 123,
        title: 'Fake Title',
        author: 'Fake Author',
        key: '/works/FAKE_KEY',
        coverUrl: '',
      );

      expect(
          () => repository.getBookDetails(book),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString().contains('error getting books details from api'))));
    });
  });
}
