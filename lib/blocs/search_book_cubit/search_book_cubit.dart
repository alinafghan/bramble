import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';

part 'search_book_state.dart';

class SearchBookCubit extends Cubit<SearchBookState> {
  final LibraryProvider libraryProvider;
  SearchBookCubit({required LibraryProvider provider})
      : libraryProvider = provider,
        super(SearchBookInitial());

  void searchBooks(String keyword) async {
    emit(SearchBookLoading());
    try {
      final books = await libraryProvider.searchBook(keyword);
      emit(SearchBookLoaded(books: books));
    } catch (e) {
      emit(SearchBookError(error: e.toString()));
    }
  }
}
