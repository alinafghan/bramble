import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/book.dart';

class Users {
  String userId;
  String? username;
  String email;
  List<Book>? savedBooks;

  Users({
    required this.userId,
    this.username,
    required this.email,
    this.savedBooks,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'savedBooks': savedBooks,
    };
  }

  factory Users.fromFirebaseUser(User firebaseUser, {String? username}) {
    return Users(
      userId: firebaseUser.uid,
      email: firebaseUser.email!,
      username: username, // Use username if available, otherwise null
      savedBooks: [],
    );
  }

  static Users fromDocument(Map<String, dynamic> doc) {
    return Users(
      userId: doc['userId'] as String,
      username: doc['username'] as String,
      email: doc['email'] as String,
      savedBooks: doc['savedBooks'] as List<Book>,
    );
  }

  Users copyWith({
    String? userId,
    String? username,
    String? email,
  }) {
    return Users(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'userId: $userId, username: $username, email: $email';
  }
}
