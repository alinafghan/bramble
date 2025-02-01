import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserProvider userProvider;

  UserBloc({required UserProvider provider})
      : userProvider = provider,
        super(const UserState.loading()) {
    on<GetUser>((event, emit) async {
      Users myUser = await provider.getCurrentUser();
      try {
        emit(UserState.success(myUser));
      } catch (e) {
        emit(const UserState.failure());
      }
    });
  }
}
