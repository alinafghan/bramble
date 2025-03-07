import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/utils/book_card.dart';
import 'package:journal_app/utils/constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    getLibrary();
    super.initState();
  }

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // return TextField(
                //   controller: searchText,

                // );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 8,
              childAspectRatio: 0.5,
            ),
            itemCount: 30,
            clipBehavior: Clip.none,
            itemBuilder: (context, i) {
              return BlocBuilder<GetLibraryBloc, GetLibraryState>(
                builder: (context, state) {
                  if (state is GetLibraryLoaded) {
                    return BookCard(book: state.booklist[i]);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primary,
                      ),
                    );
                  }
                },
              );
            }),
      ),
    );
  }

  Future<void> getLibrary() async {
    context.read<GetLibraryBloc>().add(const GetLibrary());
  }
}
