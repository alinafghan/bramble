import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';

part 'get_library_event.dart';
part 'get_library_state.dart';

class GetLibraryBloc extends Bloc<GetLibraryEvent, LibraryState> {
  LibraryProvider libraryProvider = LibraryProvider();

  GetLibraryBloc({required LibraryProvider provider})
      : libraryProvider = provider,
        super(GetLibraryInitial()) {
    on<GetLibrary>((event, emit) async {
      emit(GetLibraryLoading());
      try {
        List<Book> library = await provider.getLibrary();
        emit(GetLibraryLoaded(booklist: library));
      } catch (e) {
        emit(GetLibraryFailed());
      }
    });
    on<GetBookDetails>((event, emit) async {
      emit(GetBookDetailsInitial());
      try {
        Book book = await libraryProvider.getBookDetails(event.input);
        emit(GetAllBooksLoaded(book: book));
      } catch (e) {
        emit(GetBookDetailsError(message: e.toString()));
      }
    });
    on<SearchBook>((event, emit) async {
      emit(SearchBookLoading());
      try {
        List<Book> books = await libraryProvider.searchBook(event.keyword);
        emit(SearchBookLoaded(books: books));
      } catch (e) {
        emit(SearchBookError(error: e.toString()));
      }
    });
    on<ClearSearch>((event, emit) {
      emit(SearchCleared(libraryBooks: event.books));
    });
  }
}
