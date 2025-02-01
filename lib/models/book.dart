import 'package:journal_app/models/user.dart';

class Book {
  String bookId;
  String userId;
  String dateAdded;
  String title;
  String author;
  Users user;

  Book({
    required this.bookId,
    required this.author,
    required this.user,
    required this.userId,
    required this.dateAdded,
    required this.title,
  });

  Map<String, Object?> toDocument() {
    return {
      'author': author,
      'bookId': bookId,
      'userId': userId,
      'user': mapToUser(user),
      'dateAdded': dateAdded,
      'title': title,
    };
  }

  Map<String, Object?> mapToUser(Users user) {
    return {
      'userId': user.userId,
      'username': user.username,
      'email': user.email,
    };
  }

  static Book fromDocument(Map<String, dynamic> doc) {
    Users user = Users(
      userId: doc['user']['userId'] as String,
      username: doc['user']['username'] as String,
      email: doc['user']['email'] as String,
    );
    return Book(
      author: doc['author'] as String,
      bookId: doc['bookId'] as String,
      userId: doc['userId'] as String,
      user: user,
      dateAdded: doc['dateAdded'] as String,
      title: doc['title'] as String,
    );
  }

  Book copyWith({
    String? bookId,
    String? userId,
    String? dateAdded,
    String? title,
    String? author,
    Users? user,
  }) {
    return Book(
      author: author ?? this.author,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      dateAdded: dateAdded ?? this.dateAdded,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'user: $user,bookId: $bookId, dateAdded: $dateAdded, title: $title';
  }
}
