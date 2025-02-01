import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

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

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
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
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
    }
    return null;
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
}

// extension on User {
//   /// Maps a [firebase_auth.User] into a [User].
//   Users toUser(String userName) {
//     return Users(userId: uid, email: email!, username: userName);
//   }
// }
