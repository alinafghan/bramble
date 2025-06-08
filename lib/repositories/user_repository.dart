import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class UserRepository {
  final Logger _logger = Logger();
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();

  Future<Users> getCurrentUserFromFirebase() async {
    try {
      Users? user = await _authRepository.getCurrentUser();

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
  
}
