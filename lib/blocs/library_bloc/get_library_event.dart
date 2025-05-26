part of 'get_library_bloc.dart';

class GetLibraryEvent extends Equatable {
  const GetLibraryEvent();

  @override
  List<Object> get props => [];
}

class GetLibrary extends GetLibraryEvent {
  const GetLibrary();
}

class GetBookDetails extends GetLibraryEvent {
  final Book input;

  const GetBookDetails({required this.input});

  @override
  List<Object> get props => [input];
}

class SearchBook extends GetLibraryEvent {
  final String keyword;

  const SearchBook({required this.keyword});

  @override
  List<Object> get props => [keyword];
}

class ClearSearch extends GetLibraryEvent {
  final List<Book> books;
  const ClearSearch({required this.books});
  @override
  List<Object> get props => [books];
}
