import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'remove_book_state.dart';

class RemoveBookCubit extends Cubit<RemoveBookState> {
  BookListProvider bookProvider = BookListProvider();

  RemoveBookCubit({required BookListProvider provider})
      : bookProvider = provider,
        super(RemoveBookInitial());

  void removeBook(Book book) {
    emit(RemoveBookLoading());
    try {
      bookProvider.deleteBook(book);
      emit(RemoveBookLoaded());
    } catch (e) {
      emit(RemoveBookFailed());
    }
  }
}
