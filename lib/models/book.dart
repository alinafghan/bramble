import 'package:equatable/equatable.dart';
// ignore_for_file: must_be_immutable

class Book extends Equatable {
  final int bookId; //cover_id int from the api, string
  final String key;
  final String title;
  final String author;
  String? coverUrl;
  String? publishYear;
  String? description;
  String? excerpt;

  Book({
    required this.key,
    required this.bookId,
    required this.author,
    required this.title,
    this.coverUrl,
    this.description,
    this.excerpt,
    this.publishYear,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'bookId': bookId,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'] ?? '',
      bookId: json['cover_id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      author: json['authors'][0]['name'] ?? 'Unknown Author',
    );
  }

  factory Book.fromSearch(Map<String, dynamic> json) {
    return Book(
      key: json['key'] ?? '',
      bookId: json['cover_i'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      author: json['author_name']?[0] ?? 'Unknown Author',
      coverUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://publications.iarc.fr/uploads/media/default/0001/02/thumb_1296_default_publication.jpeg',
      publishYear: json['first_publish_year']?.toString() ?? 'No date provided',
    );
  }

  factory Book.addJson(Book book, Map<String, dynamic> json) {
    return Book(
      key: book.key,
      bookId: book.bookId,
      author: book.author,
      title: book.title,
      description: json['description'] is String
          ? json['description']
          : json['description']?['value'] ?? "No description available.",
      excerpt: json['excerpts']?[0]?['excerpt'] ??
          json['first_sentence']?['value'] ??
          'No excerpt provided',
      publishYear: json['first_publish_date'] ?? 'No date provided',
      coverUrl: book.coverUrl,
    );
  }

  factory Book.fromFirebase(Map<String, dynamic> json) {
    return Book(
      key: json['key'] ?? '',
      bookId: json['bookId'] ?? 'null',
      title: json['title'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      coverUrl: json['coverUrl'] ??
          'https://publications.iarc.fr/uploads/media/default/0001/02/thumb_1296_default_publication.jpeg',
    );
  }

  @override
  List<Object?> get props => [bookId, title, author, coverUrl, key];
}
