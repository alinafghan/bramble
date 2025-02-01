part of 'add_book_bloc.dart';

class AddBookState extends Equatable {
  const AddBookState();

  @override
  List<Object> get props => [];
}

final class AddBookLoading extends AddBookState {}

final class AddBookLoaded extends AddBookState {
  final Book book;

  const AddBookLoaded({required this.book});

  @override
  List<Object> get props => [book];
}

final class AddBookFailed extends AddBookState {}
