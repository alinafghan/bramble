import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/search_book_cubit/search_book_cubit.dart';
import 'package:journal_app/utils/book_card.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:journal_app/utils/animated_searchbar.dart';

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
    return Stack(children: [
      const SizedBox(
        child: Image(
          image: AssetImage('assets/white-paper-texture-background.jpg'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedSearchBar(
                boxShadow: false,
                prefixIcon: null,
                height: 50,
                width: MediaQuery.of(context).size.width - 20,
                color: Colors.transparent,
                textFieldColor: AppTheme.backgroundColor,
                textController: searchText,
                onSuffixTap: () {
                  setState(() {
                    searchText.clear();
                  });
                  getLibrary();
                },
                rtl: false,
                onSubmitted: (String value) {
                  debugPrint("onSubmitted value: $value");
                  searchLibrary(value);
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
                return BlocBuilder<SearchBookCubit, SearchBookState>(
                  builder: (context, searchState) {
                    return BlocBuilder<GetLibraryBloc, GetLibraryState>(
                      builder: (context, state) {
                        if (searchState is SearchBookLoaded) {
                          return BookCard(book: searchState.books[i]);
                        } else if (state is GetLibraryLoaded) {
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
                  },
                );
              }),
        ),
      ),
    ]);
  }

  Future<void> getLibrary() async {
    context.read<GetLibraryBloc>().add(const GetLibrary());
  }

  Future<void> searchLibrary(String value) async {
    context.read<SearchBookCubit>().searchBooks(value);
  }
}
