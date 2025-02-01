part of 'get_library_bloc.dart';

sealed class GetLibraryState extends Equatable {
  const GetLibraryState();

  @override
  List<Object> get props => [];
}

final class GetLibraryInitial extends GetLibraryState {}

final class GetUserLibraryLoading extends GetLibraryState {}

final class GetUserLibraryFailed extends GetLibraryState {}

final class GetUserLibraryLoaded extends GetLibraryState {
  final List<Book> booklist;

  const GetUserLibraryLoaded({required this.booklist});

  @override
  List<Object> get props => [booklist];
}
