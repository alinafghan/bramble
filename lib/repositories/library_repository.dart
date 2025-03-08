import 'dart:io';
import 'package:journal_app/models/book.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LibraryRepository {
  List<Book> allBooks = [];
  final Logger _logger = Logger();

  Future<List<Book>> getLibrary() async {
    var url = 'https://openlibrary.org/subjects/fiction.json?limit=30';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> listData =
            data['works']; //list data is a list of maps basically.
        allBooks = listData
            .whereType<Map<String, dynamic>>()
            .map((mapItem) => Book.fromJson(mapItem))
            .toList();
      }
      getCoverImage();
      return allBooks;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error getting all books from api $e');
      throw Exception('error getting books from api');
    }
  }

  Future<Book> getBookDetails(Book book) async {
    final String url = 'https://openlibrary.org${book.key}.json';

    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = json.decode(response.body);
      _logger.d('reached here first, the book is $data');
      book = Book.addJson(book, data);
      _logger.d('reached here, the book is $book');
      return book;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error getting book details from api $e');
      throw Exception('error getting books details from api');
    }
  }

  Future<void> getCoverImage() async {
    for (int i = 0; i < allBooks.length; i++) {
      var coverUrl =
          'https://covers.openlibrary.org/b/id/${allBooks[i].bookId}-L.jpg';
      allBooks[i].coverUrl = coverUrl;
    }
  }
}
