import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/repositories/auth_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({required FirebaseAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authRepository.user.listen((authUser) {
      //authentication usre event
      add(AuthenticationUserChanged(authUser));
      // add(AuthenticationLogoutRequested()); cant do this here because havent created an event handler as below
    });

    on<AuthenticationUserChanged>((event, emit) {
      //the pipeline here is FirebaseAuth.instance.authStateChanges().listen((User? user)
      if (event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
