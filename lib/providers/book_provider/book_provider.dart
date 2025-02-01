import 'package:journal_app/models/book.dart';
import 'package:journal_app/repositories/book_repository.dart';

class BookProvider {
  final BookRepository _bookRepository = BookRepository();

  Future<Book?> getBook(String bookId) async {
    Book? entry = await _bookRepository.getBookFromFirebase(bookId);
    return entry;
  }

  Future<Book> setBook(Book book) async {
    await _bookRepository.setBook(book);
    return book;
  }

  Future<List<Book>> getLibrary(String userId) async {
    List<Book> library = await _bookRepository.getLibraryFromFirebase(userId);
    return library;
  }

  Future<void> deleteBook(String userId, String bookId) async {
    await _bookRepository.deleteBook(userId, bookId);
  }
}
