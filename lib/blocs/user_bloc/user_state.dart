part of 'user_bloc.dart';

enum UserStatus { loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;

  final Users? user;

  const UserState({this.status = UserStatus.loading, this.user});

  const UserState.loading() : this();

  const UserState.success(Users user)
      : this(status: UserStatus.success, user: user);

  const UserState.failure() : this(status: UserStatus.failure);

  @override
  List<Object?> get props => [];
}
