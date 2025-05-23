import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class FirebaseAuthRepository {
  final Logger _logger = Logger();

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      //just check whether user is authenticaated or not
      final user = firebaseUser;
      return user;
    });
  }

  Future<Users> getCurrentUser() async {
    try {
      User? firebaseUser = _auth.currentUser;
      return Users.fromFirebaseUser(firebaseUser!);
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('User not found $e');
    }
  }

  Future<Users?> emailSignUp(Users user, String password) async {
    try {
      user.userId = const Uuid().v4(); //generate random user id
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.userId)
          .set(user.toDocument());
      //copywith method
      return user.copyWith(userId: credentials.user!.uid);
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
    }
    return null;
  }

  Future<void> saveUserToFirestore(Users user) async {
    user.savedBooks = []; // Initialize savedBooks to an empty list

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.userId)
        .set(user.toDocument());
  }

  Future<User?> emailLogin(String emailOrUsername, String password) async {
    String email = '';

    if (RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(emailOrUsername)) {
      email = emailOrUsername;
    } else {
      email = await getEmailFromUsername(emailOrUsername);
    }

    if (email == '') {
      _logger.e('email not found');
      return null;
    }

    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credentials.user;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
    }
    return null;
  }

  Future<User?> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
    }
    return null;
  }

  Future<UserCredential> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e("Error signing in with Google: $e");
      throw Exception("Error signing in with Google: $e");
    }
  }

  //helper functions
  Future<String> getEmailFromUsername(String username) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore
          .instance //set trules to ensure that users can access this.
          .collection("Users")
          .where("username", isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get("email") as String;
      }
    } catch (e) {
      _logger.e("Error while fetching the email from username: $e");
    }
    return ""; // Return an empty string if no match is found
  }

  Future<void> deleteUser() async {
    try {
      UserRepository userRepo = UserRepository();

      Users currentUser = await userRepo.getCurrentUserFromFirebase();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.userId)
          .delete();
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e("Error deleting user: $e");
    }
  }
}

extension on User {
  /// Maps a [firebase_auth.User] into a [User].
  Users toUser(String userName) {
    return Users(userId: uid, email: email!, username: userName);
  }
}
