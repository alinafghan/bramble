import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/blocs/get_saved_books_cubit/get_saved_books_cubit.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/screens/library_screen.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:journal_app/utils/reorderable_list.dart';
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
                context.push('/library');
              },
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MultiBlocListener(listeners: [
            BlocListener<AddBookCubit, AddBookState>(
                listener: (context, state) {
              if (state is AddBookLoaded) {
                getBooks();
              }
            }),
            BlocListener<RemoveBookCubit, RemoveBookState>(
                listener: (context, state) {
              if (state is RemoveBookLoaded) {
                getBooks();
              }
            })
          ], child: const MyReorderableList())),
    );
  }

  Future<void> getBooks() async {
    context.read<GetSavedBooksCubit>().getAllBooks();
  }
}
