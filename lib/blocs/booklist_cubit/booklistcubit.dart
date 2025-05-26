import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';

part 'booklist_state.dart';

class BookListCubit extends Cubit<SavedBooksState> {
  final BookListProvider listProvider;

  BookListCubit({required this.listProvider}) : super(GetAllBooksInitial());

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

  void addBook(Book book) {
    emit(AddBookLoading());
    try {
      listProvider.setBook(book);
      emit(AddBookLoaded(book: book));
    } catch (e) {
      emit(AddBookFailed());
    }
  }

  void removeBook(Book book) {
    emit(RemoveBookLoading());
    try {
      listProvider.deleteBook(book);
      emit(RemoveBookLoaded());
    } catch (e) {
      emit(RemoveBookFailed());
    }
  }
}
