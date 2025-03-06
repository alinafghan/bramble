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
