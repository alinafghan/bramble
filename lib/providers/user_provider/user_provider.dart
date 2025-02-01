import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/user_repository.dart';

class UserProvider {
  final UserRepository _userRepository = UserRepository();

  Future<Users> getCurrentUser() async {
    Users user = await _userRepository.getCurrentUserFromFirebase();
    return user;
  }

  Future<void> setUser(Users user) async {
    await _userRepository.setUser(user);
  }
}
