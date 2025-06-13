import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryProvider extends Mock implements LibraryProvider {}

void main() {
  group('library bloc tests', () {
    final mockProvider = MockLibraryProvider();
    final book = Book(
        title: 'Test Book',
        author: 'Test Author',
        key: 'test-key',
        bookId: 123);

    blocTest<LibraryBloc, LibraryState>(
      'getlibrary works successfully',
      build: () => LibraryBloc(libraryProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getLibrary()).thenAnswer((_) async => []);
      },
      act: (bloc) => bloc.add(const GetLibrary()),
      skip: 1, //skip loading
      expect: () => <LibraryState>[const GetLibraryLoaded(booklist: [])],
    );
    blocTest<LibraryBloc, LibraryState>(
      'getlibrary fails',
      build: () => LibraryBloc(libraryProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.getLibrary())
            .thenThrow(Exception('Failed to get library'));
      },
      act: (bloc) => bloc.add(const GetLibrary()),
      skip: 1, //skip loading
      expect: () => <LibraryState>[GetLibraryFailed()],
    );
    blocTest<GetBookDetailsCubit, GetBookDetailsState>(
      'getbookdetails works successfully',
      build: () => GetBookDetailsCubit(provider: mockProvider),
      setUp: () {
        when(() => mockProvider.getBookDetails(book))
            .thenAnswer((_) async => book);
      },
      act: (bloc) => bloc.getBookDetails(book),
      skip: 1, //skip loading
      expect: () => <GetBookDetailsState>[GetAllBooksLoaded(book: book)],
    );
    blocTest<GetBookDetailsCubit, GetBookDetailsState>(
      'getbookdetails fails',
      build: () => GetBookDetailsCubit(provider: mockProvider),
      setUp: () {
        when(() => mockProvider.getBookDetails(book))
            .thenThrow(Exception('Failed to get book details'));
      },
      act: (bloc) => bloc.getBookDetails(book),
      skip: 1, //skip loading
      expect: () => <GetBookDetailsState>[
        const GetBookDetailsError(
            message: 'Exception: Failed to get book details')
      ],
    );
    blocTest<LibraryBloc, LibraryState>(
      'searchbook works successfully',
      build: () => LibraryBloc(libraryProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.searchBook('test'))
            .thenAnswer((_) async => [book]);
      },
      act: (bloc) => bloc.add(const SearchBook(keyword: 'test')),
      skip: 1, //skip loading
      expect: () => <LibraryState>[
        SearchBookLoaded(books: [book])
      ],
    );
    blocTest<LibraryBloc, LibraryState>(
      'searchbook fails',
      build: () => LibraryBloc(libraryProvider: mockProvider),
      setUp: () {
        when(() => mockProvider.searchBook('test'))
            .thenThrow(Exception('Failed to search book'));
      },
      act: (bloc) => bloc.add(const SearchBook(keyword: 'test')),
      skip: 1, //skip loading
      expect: () => <LibraryState>[
        const SearchBookError(error: 'Exception: Failed to search book')
      ],
    );
    blocTest<LibraryBloc, LibraryState>(
      'emits SearchCleared with provided books on ClearSearch event',
      build: () => LibraryBloc(libraryProvider: mockProvider),
      act: (bloc) => bloc.add(ClearSearch(books: [book])),
      expect: () => <LibraryState>[
        SearchCleared(libraryBooks: [book]),
      ],
    );
  });
}
