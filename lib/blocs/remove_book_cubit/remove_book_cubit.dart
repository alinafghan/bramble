import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'remove_book_state.dart';

class RemoveBookCubit extends Cubit<RemoveBookState> {
  BookProvider bookProvider = BookProvider();

  RemoveBookCubit({required BookProvider provider})
      : bookProvider = provider,
        super(RemoveBookInitial());

  void removeBook(String userId, String bookId) {
    emit(RemoveBookLoading());
    try {
      bookProvider.deleteBook(userId, bookId);
      emit(RemoveBookLoaded());
    } catch (e) {
      emit(RemoveBookFailed());
    }
  }
}
