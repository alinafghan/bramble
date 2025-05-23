part of 'search_book_cubit.dart';

abstract class SearchBookState extends Equatable {
  const SearchBookState();
}

final class SearchBookInitial extends SearchBookState {
  @override
  List<Object> get props => [];
}

final class SearchBookLoading extends SearchBookState {
  @override
  List<Object> get props => [];
}

final class SearchBookLoaded extends SearchBookState {
  final List<Book> books;

  const SearchBookLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

final class SearchBookError extends SearchBookState {
  final String error;

  const SearchBookError({required this.error});

  @override
  List<Object> get props => [error];
}

final class SearchCleared extends SearchBookState {
  @override
  List<Object> get props => [];
}
