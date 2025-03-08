import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';

part 'get_book_details_state.dart';

class GetBookDetailsCubit extends Cubit<GetBookDetailsState> {
  LibraryProvider libraryProvider = LibraryProvider();

  GetBookDetailsCubit({required LibraryProvider provider})
      : libraryProvider = provider,
        super(GetBookDetailsInitial());

  void getBookDetails(Book input) async {
    emit(GetBookDetailsLoading());
    try {
      Book book = await libraryProvider.getBookDetails(input);
      emit(GetAllBooksLoaded(book: book));
    } catch (e) {
      emit(GetBookDetailsError(message: e.toString()));
    }
  }
}
