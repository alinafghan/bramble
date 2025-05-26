part of 'get_library_bloc.dart';

abstract class GetLibraryState extends Equatable {
  const GetLibraryState();

  @override
  List<Object> get props => [];
}

class GetLibraryInitial extends GetLibraryState {}

class GetLibraryLoading extends GetLibraryState {}

class GetLibraryFailed extends GetLibraryState {}

class GetLibraryLoaded extends GetLibraryState {
  final List<Book> booklist;

  const GetLibraryLoaded({required this.booklist});
}

class GetBookDetailsInitial extends GetLibraryState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsLoading extends GetLibraryState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsError extends GetLibraryState {
  final String message;

  const GetBookDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}

class GetAllBooksLoaded extends GetLibraryState {
  final Book book;

  const GetAllBooksLoaded({required this.book});

  @override
  List<Object> get props => [book];
}
