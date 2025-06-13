import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              insetPadding: const EdgeInsets.all(30),
              title: Text(
                  'Are you sure you want to remove ${book.title} from your saved?'),
              actions: [
                TextButton(
                    onPressed: () {
                      context.read<BookListCubit>().removeBook(book);
                      context.pop();
                    },
                    child: Text(
                      'Yes',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    )),
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ))
              ],
            );
          });
    }

    return BlocBuilder<BookListCubit, SavedBooksState>(
      builder: (context, state) {
        List<Book> items = [];
        if (state is GetAllBooksLoaded) {
          if (state.bookList != null) {
            items = state.bookList!;
          }
          if (state.bookList!.isNotEmpty) {
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
                          trailing: Icon(
                            HugeIcons.strokeRoundedMenu09,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: Text(item.title),
                          subtitle: Text(item.author),
                          subtitleTextStyle: TextStyle(
                            fontFamily: 'DoveMayo',
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ))
                  .toList(),
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: OverflowBox(
                    minHeight: 220,
                    maxHeight: 220,
                    child: Lottie.asset('assets/lottie/water_plants.json'),
                  ),
                ),
                const Text('No books Yet'),
              ],
            ));
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
