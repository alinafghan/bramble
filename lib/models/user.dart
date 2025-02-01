class Users {
  String userId;
  String? username;
  String email;

  Users({
    required this.userId,
    this.username,
    required this.email,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
    };
  }

  static Users fromDocument(Map<String, dynamic> doc) {
    return Users(
      userId: doc['userId'] as String,
      username: doc['username'] as String,
      email: doc['email'] as String,
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
