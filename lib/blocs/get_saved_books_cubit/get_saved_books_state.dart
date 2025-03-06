part of 'get_saved_books_cubit.dart';

class GetAllBooksState extends Equatable {
  const GetAllBooksState();

  @override
  List<Object> get props => [];
}

class GetAllBooksInitial extends GetAllBooksState {}

class GetAllBooksLoading extends GetAllBooksState {}

class GetAllBooksFailed extends GetAllBooksState {}

class GetAllBooksLoaded extends GetAllBooksState {
  List<Book>? bookList;

  GetAllBooksLoaded({required this.bookList});
}
