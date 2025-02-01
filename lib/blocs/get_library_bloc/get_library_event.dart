part of 'get_library_bloc.dart';

class GetLibraryEvent extends Equatable {
  const GetLibraryEvent();

  @override
  List<Object> get props => [];
}

class GetUserLibrary extends GetLibraryEvent {
  final Users user;

  const GetUserLibrary({required this.user});

  @override
  List<Object> get props => [user];
}
