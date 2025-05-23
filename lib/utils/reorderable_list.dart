import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/get_saved_books_cubit/get_saved_books_cubit.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:lottie/lottie.dart';

class MyReorderableList extends StatefulWidget {
  const MyReorderableList({super.key});

  @override
  State<MyReorderableList> createState() => _MyReorderableListState();
}

class _MyReorderableListState extends State<MyReorderableList> {
  @override
  Widget build(BuildContext context) {
    Future<void> deleteBookDialog(Book book) async {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(30),
              title: Text(
                  'Are you sure you want to remove ${book.title} from your saved?'),
              actions: [
                TextButton(
                    onPressed: () {
                      context.read<RemoveBookCubit>().removeBook(book);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'))
              ],
            );
          });
    }

    return BlocBuilder<GetSavedBooksCubit, GetAllBooksState>(
      builder: (context, state) {
        List<Book> items = [];
        if (state is GetAllBooksLoaded) {
          if (state.bookList != null) {
            items = state.bookList!;
          }
          return ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
              });
            },
            children: items
                .map((item) => Dismissible(
                      confirmDismiss: (DismissDirection direction) async {
                        deleteBookDialog(item);
                      },
                      background: Container(color: Colors.red),
                      key: ValueKey(item),
                      dragStartBehavior: DragStartBehavior.start,
                      onDismissed: (direction) {
                        setState(() {
                          items.remove(item);
                        });
                      },
                      child: ListTile(
                        key: ValueKey(item),
                        leading: ClipOval(
                            child: Image.network(
                          item.coverUrl!,
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        )),
                        trailing: const Icon(
                          HugeIcons.strokeRoundedMenu09,
                          color: AppTheme.text,
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.author),
                      ),
                    ))
                .toList(),
          );
        } else {
          return Center(child: Lottie.asset('assets/lottie/loading.json'));
        }
      },
    );
  }
}
