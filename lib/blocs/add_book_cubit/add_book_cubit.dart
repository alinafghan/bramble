import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'add_book_state.dart';

class AddBookCubit extends Cubit<AddBookState> {
  BookListProvider bookProvider = BookListProvider();

  AddBookCubit({required BookListProvider provider})
      : bookProvider = provider,
        super(AddBookInitial());

  void addBook(Book book) {
    emit(AddBookLoading());
    try {
      bookProvider.setBook(book);
      emit(AddBookLoaded(book: book));
    } catch (e) {
      emit(AddBookFailed());
    }
  }
}
