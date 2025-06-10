import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/book.dart';

class Users {
  String userId;
  String? username;
  String email;
  String? profileUrl;
  List<Book>? savedBooks = [];
  bool mod; //true is moderator false is user

  Users({
    required this.userId,
    this.username,
    required this.email,
    required this.mod,
    this.savedBooks,
    this.profileUrl,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'mod': mod,
      'savedBooks': savedBooks?.map((book) => book.toJson()).toList(),
      'profileUrl': profileUrl,
    };
  }

  factory Users.fromFirebaseUser(User firebaseUser,
      {String? username, bool mod = false}) {
    return Users(
      userId: firebaseUser.uid,
      email: firebaseUser.email!,
      username: username,
      profileUrl: firebaseUser.photoURL,
      mod: mod,
      savedBooks: [],
    );
  }

  static Users fromDocument(Map<String, dynamic> doc) {
    return Users(
      userId: doc['userId'],
      username: doc['username'],
      email: doc['email'],
      profileUrl: doc['profileUrl'],
      mod: doc['mod'],
      savedBooks: (doc['savedBooks'] as List<dynamic>?)
          ?.map((book) => Book.fromFirebase(book))
          .toList(),
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
      savedBooks: savedBooks,
      mod: mod,
    );
  }

  @override
  String toString() {
    return 'userId: $userId, username: $username, email: $email';
  }
}
