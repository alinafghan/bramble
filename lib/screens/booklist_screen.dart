import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/blocs/get_saved_books_cubit/get_saved_books_cubit.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/screens/library_screen.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:journal_app/utils/popup_menu.dart';

class BooklistScreen extends StatefulWidget {
  const BooklistScreen({super.key});

  @override
  State<BooklistScreen> createState() => _BooklistScreenState();
}

class _BooklistScreenState extends State<BooklistScreen> {
  @override
  void initState() {
    super.initState();
    getBooks(); // Fetch books only once when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Ensures alignment of the leading widget with padding
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0), // Add padding to the left
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Ensures the Row takes only as much space as needed
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 2.0), // Add padding to the right
                  child: Icon(
                    HugeIcons.strokeRoundedBooks01,
                    size: 21,
                  )), // Add spacing between the icon and the arrow
              PopupMenu(selectedVal: 'Book'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Add padding to the right
            child: IconButton(
              icon: const HugeIcon(
                color: AppTheme.text,
                icon: HugeIcons.strokeRoundedPlusSign,
              ),
              color: AppTheme.text,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LibraryScreen()));
              },
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MultiBlocListener(
              listeners: [
                BlocListener<AddBookCubit, AddBookState>(
                    listenWhen: (previous, current) => current is AddBookLoaded,
                    listener: (context, state) {
                      if (state is AddBookLoaded) {
                        getBooks();
                      }
                    })
              ],
              child: BlocBuilder<GetSavedBooksCubit, GetAllBooksState>(
                builder: (context, state) {
                  Book book =
                      Book(bookId: '0', author: '', title: 'No Books Added');
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
                                confirmDismiss:
                                    (DismissDirection direction) async {
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
                                  leading: const Icon(
                                    HugeIcons.strokeRoundedBook02,
                                  ),
                                  trailing: const Icon(
                                    HugeIcons.strokeRoundedMenu09,
                                    color: AppTheme.text,
                                  ),
                                  key: ValueKey(item),
                                  title: Text(item.title),
                                  subtitle: Text(item.author),
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ));
                  }
                },
              ))),
    );
  }

  Future<void> getBooks() async {
    context.read<GetSavedBooksCubit>().getAllBooks();
  }

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
                    getBooks();
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
}
