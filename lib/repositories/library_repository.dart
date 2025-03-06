import 'package:flutter/material.dart';
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
    } catch (e) {
      _logger.e('error getting all books from api $e');
      throw Exception('error getting books from api');
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
