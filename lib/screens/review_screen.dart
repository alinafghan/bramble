import 'package:flutter/material.dart';
import 'package:journal_app/models/book.dart';

class ReviewScreen extends StatefulWidget {
  final Book book;
  const ReviewScreen({super.key, required this.book});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Review ${widget.book.title}'),
          TextField(
            controller: reviewTextController,
          ),
          TextButton(onPressed: () {}, child: const Text('Post Review')),
        ],
      ),
    );
  }
}
