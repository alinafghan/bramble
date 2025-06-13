import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/report.dart';
import 'package:journal_app/models/user.dart';

class Review {
  String id;
  Users user;
  Book book;
  String text;
  String createdAt;
  int numLikes;
  bool isLikedByCurrentUser = false;
  List<Report>? reports;

  Review({
    required this.text,
    required this.numLikes,
    required this.id,
    required this.user,
    required this.book,
    required this.createdAt,
    this.reports,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt,
      'user': user.toDocument(),
      'book': book.toJson(),
      'numLikes': numLikes,
      'reports': reports?.map((r) => r.toMap()).toList() ?? [],
    };
  }

  static Review fromDocument(Map<String, dynamic> doc) {
    Users user = Users(
      userId: doc['user']['userId'] as String,
      username: doc['user']['username'] as String,
      email: doc['user']['email'] as String,
      profileUrl: doc['user']['profileUrl'] as String?,
      mod: doc['user']['mod'] as bool,
    );
    Book book = Book(
      key: doc['book']['key'] as String,
      bookId: doc['book']['bookId'],
      author: doc['book']['author'] as String,
      title: doc['book']['title'] as String,
    );
    List<Report>? reports;
    if (doc['reports'] != null) {
      reports = List<Map<String, dynamic>>.from(doc['reports'])
          .map((r) => Report.fromMap(r))
          .toList();
    }
    return Review(
      id: doc['id'] as String,
      user: user,
      book: book,
      createdAt: doc['createdAt'] as String,
      text: doc['text'] as String,
      numLikes: doc['numLikes'] as int,
      reports: reports,
    );
  }

  // @override
  // String toString() {
  //   return 'username: ${user.username} date: $date, content: $content';
  // }
}
