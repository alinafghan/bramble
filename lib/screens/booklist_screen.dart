import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/add_book_bloc/add_book_bloc.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
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

  final TextEditingController _addBookController = TextEditingController();
  final TextEditingController _addAuthorController = TextEditingController();
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
                addBookDialog();
              },
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MultiBlocListener(
              listeners: [
                BlocListener<AddBookBloc, AddBookState>(
                    listenWhen: (previous, current) => current is AddBookLoaded,
                    listener: (context, state) {
                      if (state is AddBookLoaded) {
                        context
                            .read<GetLibraryBloc>()
                            .add(GetUserLibrary(user: state.book.user));
                      }
                    })
              ],
              child: BlocBuilder<GetLibraryBloc, GetLibraryState>(
                builder: (context, state) {
                  List<Book> items = [];
                  if (state is GetUserLibraryLoaded) {
                    items = state.booklist;
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
    UserProvider provider = UserProvider();
    Users user = await provider.getCurrentUser();

    // if (mounted) {
    context.read<GetLibraryBloc>().add(GetUserLibrary(user: user));
    // }
  }

  Future<void> deleteBookDialog(Book book) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            title: Text('Are you sure you want to delete ${book.title}'),
            actions: [
              TextButton(
                  onPressed: () {
                    context
                        .read<RemoveBookCubit>()
                        .removeBook(book.user.userId, book.bookId);
                    getBooks();
                    // context
                    //     .read<GetLibraryBloc>()
                    //     .add(GetUserLibrary(user: book.user));
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

  Future<void> addBookDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.all(50),
            title: const Text('Add new book to library'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _addBookController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Title'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _addAuthorController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('author'),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    addBook();
                    // getBooks();
                    Navigator.pop(context);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  void addBook() {
    String bookTitle = _addBookController.text.trim();
    String authorName = _addAuthorController.text.trim();

    context.read<AddBookBloc>().add(AddBook(
        book: Book(
            author: authorName,
            bookId: '',
            user: Users(userId: '', email: ''),
            userId: '',
            dateAdded: '',
            title: bookTitle)));
  }
}
