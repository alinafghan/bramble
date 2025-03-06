import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'add_book_event.dart';
part 'add_book_state.dart';

class AddBookBloc extends Bloc<AddBookEvent, AddBookState> {
  BookListProvider bookProvider = BookListProvider();

  AddBookBloc({required BookListProvider provider})
      : bookProvider = provider,
        super(AddBookLoading()) {
    on<AddBook>((event, emit) async {
      emit(AddBookLoading());
      try {
        Book? book = await provider.setBook(event.book);
        emit(AddBookLoaded(book: book));
      } catch (e) {
        emit(AddBookFailed());
      }
    });
  }
}
