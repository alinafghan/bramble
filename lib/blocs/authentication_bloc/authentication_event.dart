part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User? user;

  const AuthenticationUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  const AuthenticationLoginRequested(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}

class AuthenticationSignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  const AuthenticationSignUpRequested(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}

class GetUserEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AddProfilePicEvent extends AuthenticationEvent {
  final String profileUrl;

  const AddProfilePicEvent({required this.profileUrl});

  @override
  List<Object?> get props => [profileUrl];
}

class ChangeUsernameEvent extends AuthenticationEvent {
  final String newUsername;

  const ChangeUsernameEvent({required this.newUsername});

  @override
  List<Object?> get props => [newUsername];
}
