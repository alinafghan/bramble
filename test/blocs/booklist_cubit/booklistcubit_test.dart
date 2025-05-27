import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockBookListProvider extends Mock implements BookListProvider {}

void main() {
  group('ReviewCubit Tests', () {
    final mockProvider = MockBookListProvider();
    final book = Book(
        key: '1', bookId: 1, author: 'Author', title: 'Title', coverUrl: 'url');

    blocTest<BookListCubit, SavedBooksState>(
      'getallbooks successfully',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () =>
          when(() => mockProvider.returnBookList()).thenAnswer((_) async => []),
      act: (cubit) => cubit.getAllBooks(),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[const GetAllBooksLoaded(bookList: [])],
    );

    blocTest<BookListCubit, SavedBooksState>(
      'getallbooks failed',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () => when(() => mockProvider.returnBookList())
          .thenThrow(Exception('Failed to get books')),
      act: (cubit) => cubit.getAllBooks(),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[GetAllBooksFailed()],
    );

    blocTest<BookListCubit, SavedBooksState>(
      'addbook successfully',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () =>
          when(() => mockProvider.setBook(book)).thenAnswer((_) async => book),
      act: (cubit) => cubit.addBook(book),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[AddBookLoaded(book: book)],
    );
    blocTest<BookListCubit, SavedBooksState>(
      'addbook failed',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () => when(() => mockProvider.setBook(book))
          .thenThrow(Exception('Failed to add book')),
      act: (cubit) => cubit.addBook(book),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[AddBookFailed()],
    );
    blocTest<BookListCubit, SavedBooksState>(
      'removebook successfully',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () =>
          when(() => mockProvider.deleteBook(book)).thenAnswer((_) async {}),
      act: (cubit) => cubit.removeBook(book),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[RemoveBookLoaded()],
    );
    blocTest<BookListCubit, SavedBooksState>(
      'removebook failed',
      build: () => BookListCubit(listProvider: mockProvider),
      setUp: () => when(() => mockProvider.deleteBook(book))
          .thenThrow(Exception('Failed to remove book')),
      act: (cubit) => cubit.removeBook(book),
      skip: 1, //skip loading
      expect: () => <SavedBooksState>[RemoveBookFailed()],
    );
  });
}
