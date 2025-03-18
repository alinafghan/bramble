part of 'get_book_details_cubit.dart';

abstract class GetBookDetailsState extends Equatable {
  const GetBookDetailsState();
}

class GetBookDetailsInitial extends GetBookDetailsState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsLoading extends GetBookDetailsState {
  @override
  List<Object> get props => [];
}

class GetBookDetailsError extends GetBookDetailsState {
  final String message;

  const GetBookDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}

class GetAllBooksLoaded extends GetBookDetailsState {
  final Book book;

  const GetAllBooksLoaded({required this.book});

  @override
  List<Object> get props => [book];
}
