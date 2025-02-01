import 'package:journal_app/models/user.dart';

class Journal {
  String id;
  String date;
  String content;
  Users user;

  Journal({
    required this.id,
    required this.user,
    required this.date,
    required this.content,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'user': userToMap(user),
      'date': date,
      'content': content,
    };
  }

  Map<String, Object?> userToMap(Users user) {
    return {
      'userId': user.userId,
      'username': user.username,
      'email': user.email,
    };
  }

  static Journal fromDocument(Map<String, dynamic> doc) {
    Users user = Users(
      userId: doc['user']['userId'] as String,
      username: doc['user']['username'] as String,
      email: doc['user']['email'] as String,
    );

    return Journal(
      id: doc['id'] as String,
      user: user,
      date: doc['date'] as String,
      content: doc['content'] as String,
    );
  }

  Journal copyWith({
    Users? user,
    String? id,
    String? date,
    String? content,
  }) {
    return Journal(
      user: user ?? this.user,
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }

  @override
  String toString() {
    return 'username: ${user.username} date: $date, content: $content';
  }
}
