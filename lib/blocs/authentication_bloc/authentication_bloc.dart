import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({required this.authRepository})
      : super(const AuthenticationState.unknown()) {
    _userSubscription = authRepository.user.listen((authUser) {
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

    on<GetUserEvent>((event, emit) async {
      emit(GetUserLoading());
      try {
        Users user = await authRepository.getCurrentUserFromFirebase();
        emit(GetUserLoaded(myUser: user));
      } catch (e) {
        emit(GetUserFailed(message: e.toString()));
      }
    });

    on<AddProfilePicEvent>((event, emit) async {
      emit(AddProfilePicLoading());
      try {
        Users? user = await authRepository.addProfilePic(event.profileUrl);
        emit(AddProfilePicLoaded(myUser: user!));
        final updatedUser =
            await authRepository.getCurrentUser(); // Fetch latest
        emit(GetUserLoaded(myUser: updatedUser));
      } catch (e) {
        emit(AddProfilePicFailure(message: e.toString()));
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
