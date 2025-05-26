part of 'get_library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

class GetLibraryInitial extends LibraryState {}

class GetLibraryLoading extends LibraryState {}

class GetLibraryFailed extends LibraryState {}

class GetLibraryLoaded extends LibraryState {
  final List<Book> booklist;

  const GetLibraryLoaded({required this.booklist});
}

class GetBookDetailsInitial extends LibraryState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsLoading extends LibraryState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsError extends LibraryState {
  final String message;

  const GetBookDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}

class GetAllBooksLoaded extends LibraryState {
  final Book book;

  const GetAllBooksLoaded({required this.book});

  @override
  List<Object> get props => [book];
}

final class SearchBookInitial extends LibraryState {
  @override
  List<Object> get props => [];
}

final class SearchBookLoading extends LibraryState {
  @override
  List<Object> get props => [];
}

final class SearchBookLoaded extends LibraryState {
  final List<Book> books;

  const SearchBookLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

final class SearchBookError extends LibraryState {
  final String error;

  const SearchBookError({required this.error});

  @override
  List<Object> get props => [error];
}

final class SearchCleared extends LibraryState {
  final List<Book> libraryBooks;
  const SearchCleared({required this.libraryBooks});
  @override
  List<Object> get props => [libraryBooks];
}
