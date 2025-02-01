part of 'add_book_bloc.dart';

class AddBookEvent extends Equatable {
  const AddBookEvent();

  @override
  List<Object> get props => [];
}

class AddBook extends AddBookEvent {
  final Book book;

  const AddBook({required this.book});

  @override
  List<Object> get props => [book];
}
