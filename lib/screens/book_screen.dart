import 'package:flutter/material.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/book_card.dart';

class BookScreen extends StatelessWidget {
  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BookCard(book: book),
    );
  }
}
