import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/models/book.dart';

void main() {
  group('LibraryState', () {
    test('GetLibraryInitial supports value comparison', () {
      expect(GetLibraryInitial(), GetLibraryInitial());
    });

    test('GetLibraryLoading supports value comparison', () {
      expect(GetLibraryLoading(), GetLibraryLoading());
    });

    test('GetLibraryLoaded supports value comparison', () {
      expect(
        const GetLibraryLoaded(booklist: []),
        const GetLibraryLoaded(booklist: []),
      );
    });

    test('GetLibraryFailed supports value comparison', () {
      expect(GetLibraryFailed(), GetLibraryFailed());
    });

    test('SearchBookLoading supports value comparison', () {
      expect(SearchBookLoading(), SearchBookLoading());
    });

    test('SearchBookLoaded supports value comparison', () {
      final book = Book(title: 'a', author: 'b', key: '1', bookId: 1);
      expect(
        SearchBookLoaded(books: [book]),
        SearchBookLoaded(books: [book]),
      );
    });

    test('SearchBookError supports value comparison', () {
      expect(
        const SearchBookError(error: 'error'),
        const SearchBookError(error: 'error'),
      );
    });

    test('SearchCleared supports value comparison', () {
      final book = Book(title: 'a', author: 'b', key: '1', bookId: 1);
      expect(
        SearchCleared(libraryBooks: [book]),
        SearchCleared(libraryBooks: [book]),
      );
    });

    test('GetBookDetailsInitial supports value comparison', () {
      expect(GetBookDetailsInitial(), GetBookDetailsInitial());
    });

    test('GetAllBooksLoaded supports value comparison', () {
      final book = Book(title: 'a', author: 'b', key: '1', bookId: 1);
      expect(GetAllBooksLoaded(book: book), GetAllBooksLoaded(book: book));
    });

    test('GetBookDetailsError supports value comparison', () {
      expect(
        const GetBookDetailsError(message: 'error'),
        const GetBookDetailsError(message: 'error'),
      );
    });
  });
}
