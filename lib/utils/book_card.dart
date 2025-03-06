import 'package:flutter/material.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  Future<void> addBookDialog(BuildContext context, Book book) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.all(50),
            title: const Text('Save book to your book list?'),
            children: [
              TextButton(
                  onPressed: () {
                    context.read<AddBookCubit>().addBook(book);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      GestureDetector(
        onDoubleTap: () {},
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  book.coverUrl ??
                      'https://publications.iarc.fr/uploads/media/default/0001/02/thumb_1296_default_publication.jpeg',
                  fit: BoxFit.contain,
                  height: 180,
                  width: double.infinity,
                ),
                Flexible(
                    child: Text(
                  book.title,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Flexible(
                    child: Text(
                  book.author,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: -6,
        right: -6,
        child: FloatingActionButton(
          heroTag: book.bookId,
          onPressed: () {
            addBookDialog(context, book);
          },
          shape: const CircleBorder(),
          mini: true,
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.text,
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }
}
