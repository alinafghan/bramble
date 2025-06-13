import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/models/book.dart';
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
  List<Book> libraryBooks = [];

  @override
  void initState() {
    super.initState();
    getLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
                  context.read<LibraryBloc>().add(ClearSearch(
                      books: libraryBooks)); // Reset to show cached data
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
          child: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, libraryState) {
              List searchedBooks = [];
              List books = [];

              if (libraryState is SearchBookLoaded) {
                searchedBooks = libraryState.books; //searchedbooks are saved
                books = searchedBooks; //displayed booksare the searched books
              } else if (libraryState is GetLibraryLoaded) {
                libraryBooks = libraryState.booklist; //all books are fetched
                books = libraryBooks; //displayed books are all books
              } else if (libraryState is SearchCleared) {
                books =
                    libraryState.libraryBooks; //sdisplayed books are all books?
              } else {
                books = books;
              }

              if (books.isEmpty) {
                return Center(
                  child: Lottie.asset('assets/plant.json'),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.5,
                ),
                itemCount: books.length,
                clipBehavior: Clip.none,
                itemBuilder: (context, i) {
                  return BookCard(book: books[i]);
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
    context.read<LibraryBloc>().add(const GetLibrary());
  }

  Future<void> searchLibrary(String value) async {
    context.read<LibraryBloc>().add(SearchBook(keyword: value));
  }
}
