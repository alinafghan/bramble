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
