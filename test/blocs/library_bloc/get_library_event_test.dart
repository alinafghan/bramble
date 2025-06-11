import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/models/book.dart';

void main() {
  group('GetLibraryEvent', () {
    test('GetLibrary supports value comparison', () {
      expect(const GetLibrary(), const GetLibrary());
    });

    test('GetBookDetails supports value comparison', () {
      final book = Book(title: 'a', author: 'b', key: '1', bookId: 1);
      expect(GetBookDetails(input: book), GetBookDetails(input: book));
    });

    test('SearchBook supports value comparison', () {
      expect(
        const SearchBook(keyword: 'flutter'),
        const SearchBook(keyword: 'flutter'),
      );
    });

    test('ClearSearch supports value comparison', () {
      final book = Book(title: 'a', author: 'b', key: '1', bookId: 1);
      expect(
        ClearSearch(books: [book]),
        ClearSearch(books: [book]),
      );
    });
  });
}
