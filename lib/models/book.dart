import 'package:equatable/equatable.dart';

class Book extends Equatable {
  int bookId; //cover_id int from the api, string
  String title;
  String author;
  String? coverUrl;

  Book({
    required this.bookId,
    required this.author,
    required this.title,
    this.coverUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['cover_id'] ?? 'null',
      title: json['title'] ?? 'Unknown Title',
      author: json['authors'][0]['name'] ?? 'Unknown Author',
    );
  }

  factory Book.fromFirebase(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'] ?? 'null',
      title: json['title'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      coverUrl: json['coverUrl'] ??
          'https://publications.iarc.fr/uploads/media/default/0001/02/thumb_1296_default_publication.jpeg',
    );
  }

  @override
  List<Object?> get props => [bookId, title, author, coverUrl];
}
