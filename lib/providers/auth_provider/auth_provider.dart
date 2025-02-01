import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';

class MyAuthProvider {
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();

  Future<Users?> emailSignUp(Users user, String password) async {
    return await _authRepository.emailSignUp(user, password);
  }

  Future<User?> emailLogin(String emailOrUsername, String password) async {
    return await _authRepository.emailLogin(emailOrUsername, password);
  }

  Future<User?> signOut() async {
    return await _authRepository.signOut();
  }
}
