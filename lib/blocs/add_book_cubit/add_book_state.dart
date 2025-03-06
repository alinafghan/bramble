part of 'add_book_cubit.dart';

sealed class AddBookState extends Equatable {
  const AddBookState();

  @override
  List<Object> get props => [];
}

final class AddBookInitial extends AddBookState {}

class AddBookLoading extends AddBookState {}

class AddBookFailed extends AddBookState {}

class AddBookLoaded extends AddBookState {
  Book book;

  AddBookLoaded({required this.book});
}
