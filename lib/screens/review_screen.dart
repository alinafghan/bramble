import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/set_review_cubit/set_review_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';

class SetReviewScreen extends StatefulWidget {
  final Book book;
  const SetReviewScreen({super.key, required this.book});

  @override
  State<SetReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<SetReviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<SetReviewCubit, SetReviewState>(
        builder: (context, state) {
          return Column(
            children: [
              Text('Review ${widget.book.title}'),
              TextField(
                controller: reviewTextController,
              ),
              TextButton(
                  onPressed: () {
                    setReview(context, widget.book);
                    Navigator.pop(context);
                  },
                  child: const Text('Post Review')),
            ],
          );
        },
      ),
    );
  }

  void setReview(BuildContext context, Book book) {
    context.read<SetReviewCubit>().setReview(
          Review(
            id: '',
            user: Users(userId: '', email: ''), //current user,
            book: book,
            text: reviewTextController.text,
            createdAt:
                DateTime.now().toString(), //current time // Example rating
          ),
          book,
        );
  }
}
