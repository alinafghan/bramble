part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {
  final String userId;

  const GetUser({required this.userId});

  @override
  List<Object> get props => [userId];
}
