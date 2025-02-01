part of 'remove_book_cubit.dart';

class RemoveBookState extends Equatable {
  const RemoveBookState();

  @override
  List<Object> get props => [];
}

final class RemoveBookInitial extends RemoveBookState {}

final class RemoveBookLoading extends RemoveBookState {}

final class RemoveBookLoaded extends RemoveBookState {}

final class RemoveBookFailed extends RemoveBookState {}
