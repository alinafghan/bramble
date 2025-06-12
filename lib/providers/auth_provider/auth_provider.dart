import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';

class MyAuthProvider {
  final AuthRepository _authRepository;

  MyAuthProvider({AuthRepository? repo})
      : _authRepository = repo ?? AuthRepository();

  Future<Users?> emailSignUp(Users user, String password) async {
    return await _authRepository.emailSignUp(user, password);
  }

  Future<User?> emailLogin(String emailOrUsername, String password) async {
    return await _authRepository.emailLogin(emailOrUsername, password);
  }

  Future<User?> signOut() async {
    return await _authRepository.signOut();
  }

  Future<UserCredential> signUpWithGoogle() async {
    return await _authRepository.signUpWithGoogle();
  }

  Future<void> saveUserToFirestore(Users user) async {
    return await _authRepository.saveUserToFirestore(user);
  }

  Future<void> deleteUser() async {
    return await _authRepository.deleteUser();
  }

  Future<Users> getCurrentUser() async {
    Users user = await _authRepository.getCurrentUserFromFirebase();
    return user;
  }

  Future<void> setUser(Users user) async {
    await _authRepository.setUser(user);
  }
}
