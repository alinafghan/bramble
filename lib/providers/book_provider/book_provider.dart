import 'package:journal_app/models/book.dart';
import 'package:journal_app/repositories/book_list_repository.dart';

class BookListProvider {
  final BookListRepository _bookRepository;
  BookListProvider({BookListRepository? repo})
      : _bookRepository = repo ?? BookListRepository();

  Future<Book> setBook(Book book) async {
    _bookRepository.saveBook(book);
    return book;
  }

  Future<void> deleteBook(Book book) async {
    _bookRepository.removeBook(book);
  }

  Future<List<Book>?> returnBookList() async {
    return _bookRepository.returnBookList();
  }
}
