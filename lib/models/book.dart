import 'dart:ui';

class Book {
  int bookId; //cover_id
  String title;
  String author;
  String? coverUrl;

  Book({
    required this.bookId,
    required this.author,
    required this.title,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['cover_id'] ?? 'null',
      title: json['title'] ?? 'Unknown Title',
      author: json['authors'][0]['name'] ?? 'Unknown Author',
    );
  }
}
