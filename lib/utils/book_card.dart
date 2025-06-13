import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            insetPadding: const EdgeInsets.all(50),
            title: const Text('Add book to your book list?'),
            children: [
              TextButton(
                  onPressed: () {
                    context.read<BookListCubit>().addBook(book);
                    context.pop();
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      GestureDetector(
        onTap: () {
          context.push('/book', extra: book);
        },
        child: Card(
          surfaceTintColor: Colors.transparent,
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: book.coverUrl ??
                        'https://publications.iarc.fr/uploads/media/default/0001/02/thumb_1296_default_publication.jpeg',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 5.4,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                    child: Text(
                  book.title,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 12,
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
          heroTag: null,
          onPressed: () {
            addBookDialog(context, book);
          },
          shape: const CircleBorder(),
          mini: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }
}
