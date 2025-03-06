import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:logger/logger.dart';

class BookListRepository {
  final Logger _logger = Logger();
  FirebaseAuthRepository repo = FirebaseAuthRepository();

  Future<List<Book>?> returnBookList() async {
    try {
      Users currentUser = await repo.getCurrentUser();
      return currentUser.savedBooks;
    } catch (e) {
      _logger.e('error returning booklist $e. user might be null');
      throw Exception('Exception thrown');
    }
  }

  void saveBook(Book book) async {
    try {
      Users? currentUser = await repo.getCurrentUser();
      currentUser?.savedBooks?.add(book);
    } catch (e) {
      _logger.e('error saving book $e');
    }
  }

  void removeBook(Book book) async {
    try {
      Users? currentUser = await repo.getCurrentUser();
      currentUser?.savedBooks?.remove(book);
    } catch (e) {
      _logger.e('error saving book $e');
    }
  }
}
