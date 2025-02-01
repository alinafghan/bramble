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
