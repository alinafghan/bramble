import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journal_app/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class AuthRepository {
  // final Logger _logger = Logger();
  // final usersCollection = FirebaseFirestore.instance.collection('Users');

  // AuthRepository({
  //   FirebaseAuth? firebaseAuth,
  // }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  // final FirebaseAuth _auth;
  final Logger _logger = Logger();
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        googleSignIn =
            googleSignIn ?? GoogleSignIn(), // fallback for production
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('Users');

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

  Future<void> setUser(Users user) async {
    try {
      await usersCollection.doc(user.userId).set(user.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('Error while setting user: $e');
      return;
    }
  }

  Future<Users> getCurrentUserFromFirebase() async {
    try {
      Users? user = await getCurrentUser();

      // ignore: unnecessary_null_comparison
      if (user == null) {
        throw Exception("User is not logged in");
      }

      QuerySnapshot querySnapshot = await usersCollection
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return Users.fromDocument(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("No user found with the given email.");
      }
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  Future<Users?> addProfilePic(String profileUrl) async {
    try {
      Users? user = await getCurrentUserFromFirebase();

      final userDocRef = usersCollection.doc(user.userId);
      await userDocRef.update({
        'profileUrl': profileUrl,
      });

      final updatedDoc = await userDocRef.get();
      return Users.fromDocument(updatedDoc.data() as Map<String, dynamic>);
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection');
    } catch (e) {
      _logger.e("Failed to update profile picture: $e");
      throw Exception("Failed to update profile picture: $e");
    }
  }

  Future<Users?> emailSignUp(Users user, String password) async {
    try {
      user.userId = const Uuid().v4(); //generate random user id
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      _firestore.collection('Users').doc(user.userId).set(user.toDocument());
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

    await _firestore
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
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
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
      QuerySnapshot snapshot =
          await _firestore //set trules to ensure that users can access this.
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
      Users currentUser = await getCurrentUserFromFirebase();

      await _firestore.collection('Users').doc(currentUser.userId).delete();
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e("Error deleting user: $e");
    }
  }

  Future<String> updateUsername(String username) async {
    try {
      Users currentUser = await getCurrentUserFromFirebase();
      Users updatedUser = currentUser.copyWith(username: username);
      await _firestore
          .collection('Users')
          .doc(currentUser.userId)
          .update(updatedUser.toDocument());
      return username;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e("Error updating username: $e");
      throw Exception(e);
    }
  }
}

extension on User {
  /// Maps a [firebase_auth.User] into a [User].
  // ignore: unused_element
  Users toUser(String userName, bool mod) {
    return Users(userId: uid, email: email!, username: userName, mod: mod);
  }
}
