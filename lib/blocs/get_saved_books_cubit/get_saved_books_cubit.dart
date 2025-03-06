import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'get_saved_books_state.dart';

class GetSavedBooksCubit extends Cubit<GetAllBooksState> {
  BookListProvider listProvider = BookListProvider();

  GetSavedBooksCubit({required BookListProvider provider})
      : listProvider = provider,
        super(GetAllBooksInitial());

  void getAllBooks() async {
    emit(GetAllBooksLoading());
    try {
      List<Book>? list = await listProvider.returnBookList();
      emit(GetAllBooksLoaded(bookList: list));
    } catch (e) {
      emit(GetAllBooksFailed());
      throw Exception('failture in getting all books $e');
    }
  }
}
