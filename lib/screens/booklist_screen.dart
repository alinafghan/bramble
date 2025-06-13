import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
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
    context.read<AuthenticationBloc>().add(GetUserEvent());
    getBooks(); // Fetch books only once when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Ensures alignment of the leading widget with padding
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Add padding to the left
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is GetUserLoaded) {
                return PopupMenu(
                  selectedVal: 'Book',
                  isModerator: state.myUser.mod,
                );
              } else {
                return const PopupMenu(
                  selectedVal: 'Book',
                  isModerator: false,
                );
              }
            },
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
            BlocListener<BookListCubit, SavedBooksState>(
                listener: (context, state) {
              if (state is AddBookLoaded) {
                getBooks();
              }
            }),
            BlocListener<BookListCubit, SavedBooksState>(
                listener: (context, state) {
              if (state is RemoveBookLoaded) {
                getBooks();
              }
            })
          ], child: const MyReorderableList())),
    );
  }

  Future<void> getBooks() async {
    context.read<BookListCubit>().getAllBooks();
  }
}
