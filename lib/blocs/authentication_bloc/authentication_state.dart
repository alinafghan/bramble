part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;

  final User? user;

  const AuthenticationState(
      {this.status = AuthenticationStatus.unknown, this.user});

  const AuthenticationState.unknown()
      : this(); //if state is unknown return empty state

  const AuthenticationState.authenticated(User user)
      : this(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}

class GetUserLoading extends AuthenticationState {}

class GetUserLoaded extends AuthenticationState {
  final Users myUser;

  const GetUserLoaded({required this.myUser});
}

class GetUserFailed extends AuthenticationState {
  final String message;

  const GetUserFailed({required this.message});
}

class AddProfilePicLoading extends AuthenticationState {}

class AddProfilePicLoaded extends AuthenticationState {
  final Users myUser;

  const AddProfilePicLoaded({required this.myUser});
}

class AddProfilePicFailure extends AuthenticationState {
  final String message;

  const AddProfilePicFailure({required this.message});
}

class ChangeUsernameLoading extends AuthenticationState {}

class ChangeUsernameLoaded extends AuthenticationState {
  final String newUsername;

  const ChangeUsernameLoaded({required this.newUsername});
}

class ChangeUsernameFailure extends AuthenticationState {
  final String message;

  const ChangeUsernameFailure({required this.message});
}
