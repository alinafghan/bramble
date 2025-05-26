import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/search_book_cubit/search_book_cubit.dart';
import 'package:journal_app/utils/book_card.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:journal_app/utils/animated_searchbar.dart';
import 'package:lottie/lottie.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController searchText = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // const SizedBox(
      //   child: Image(
      //     image: AssetImage('assets/white-paper-texture-background.jpg'),
      //     fit: BoxFit.cover,
      //     height: double.infinity,
      //     width: double.infinity,
      //   ),
      // ),
      Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedSearchBar(
                closeSearchOnSuffixTap: true,
                boxShadow: false,
                prefixIcon: null,
                height: 50,
                width: MediaQuery.of(context).size.width - 20,
                color: Colors.transparent,
                textFieldColor: AppTheme.backgroundColor,
                textController: searchText,
                onSuffixTap: () {
                  searchText.clear();
                  context
                      .read<SearchBookCubit>()
                      .clearSearch(); // Reset to show cached data
                },
                rtl: false,
                onSubmitted: (String value) {
                  if (value.isNotEmpty) {
                    searchLibrary(value);
                  } else {
                    getLibrary();
                  }
                },
                textInputAction: TextInputAction.search,
                searchBarOpen: (a) {
                  a = 0;
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SearchBookCubit, SearchBookState>(
            builder: (context, searchState) {
              return BlocBuilder<GetLibraryBloc, GetLibraryState>(
                builder: (context, libraryState) {
                  List libraryBooks = [];
                  List searchedBooks = [];
                  List books = [];

                  if (searchState is SearchBookLoaded) {
                    searchedBooks = searchState.books;
                    books = searchedBooks;
                  } else if (libraryState is GetLibraryLoaded) {
                    libraryBooks = libraryState.booklist;
                    books = libraryBooks;
                  } else if (searchState is SearchCleared) {
                    books = libraryBooks;
                  }

                  if (books.isEmpty) {
                    return Center(
                      child: Lottie.asset('assets/plant.json'),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: books.length,
                    clipBehavior: Clip.none,
                    itemBuilder: (context, i) {
                      return BookCard(book: books[i]);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    ]);
  }

  Future<void> getLibrary() async {
    searchText.clear();
    isSearching = false;
    context.read<GetLibraryBloc>().add(const GetLibrary());
  }

  Future<void> searchLibrary(String value) async {
    context.read<SearchBookCubit>().searchBooks(value);
  }
}
