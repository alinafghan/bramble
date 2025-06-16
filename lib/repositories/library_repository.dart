import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journal_app/models/book.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LibraryRepository {
  List<Book> allBooks = [];
  List<Book> searchedBooks = [];
  final Logger _logger = Logger();
  final http.Client client;

  LibraryRepository({http.Client? client}) : client = client ?? http.Client();

  Future<List<Book>> getLibrary() async {
    var url = 'https://openlibrary.org/subjects/fiction.json?limit=30';
    try {
      var response = await client.get(Uri.parse(url));
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
      rethrow;
    } catch (e) {
      _logger.e('error getting all books from api $e');
      throw Exception('error getting books from api');
    }
  }

  Future<List<Book>> searchBook(String keyword) async {
    var url = "https://openlibrary.org/search.json?q=$keyword&limit=30";
    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> listData =
            data['docs']; //list data is a list of maps basically.

        searchedBooks = listData
            .whereType<Map<String, dynamic>>()
            .map((mapItem) => Book.fromSearch(mapItem))
            .toList();
        debugPrint('the books are $allBooks');
      }
      getCoverImage();
      return searchedBooks;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      rethrow;
    } catch (e) {
      _logger.e('error searching books from api $e');
      throw Exception(
          'There has been a server error while searching for books. Please try again');
    }
  }

  Future<Book> getBookDetails(Book book) async {
    final String url = 'https://openlibrary.org${book.key}.json';

    try {
      var response = await client.get(Uri.parse(url));
      Map<String, dynamic> data = json.decode(response.body);
      book = Book.addJson(book, data);
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
