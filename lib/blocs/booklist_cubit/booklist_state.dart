part of 'booklistcubit.dart';

class SavedBooksState extends Equatable {
  const SavedBooksState();

  @override
  List<Object> get props => [];
}

class GetAllBooksInitial extends SavedBooksState {}

class GetAllBooksLoading extends SavedBooksState {}

class GetAllBooksFailed extends SavedBooksState {}

class GetAllBooksInternetError extends SavedBooksState {}

class GetAllBooksLoaded extends SavedBooksState {
  final List<Book>? bookList;

  const GetAllBooksLoaded({required this.bookList});
}

final class AddBookInitial extends SavedBooksState {}

class AddBookLoading extends SavedBooksState {}

class AddBookFailed extends SavedBooksState {}

class AddBookLoaded extends SavedBooksState {
  final Book book;

  const AddBookLoaded({required this.book});
}

final class RemoveBookInitial extends SavedBooksState {}

final class RemoveBookLoading extends SavedBooksState {}

final class RemoveBookLoaded extends SavedBooksState {}

final class RemoveBookFailed extends SavedBooksState {}
