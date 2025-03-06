import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:logger/logger.dart';

class BookListRepository {
  final Logger _logger = Logger();
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  UserRepository userRepo = UserRepository();
  FirebaseAuthRepository repo = FirebaseAuthRepository();

  Future<List<Book>?> returnBookList() async {
    try {
      Users currentUser = await userRepo.getCurrentUserFromFirebase();
      _logger.d('returning the current users saved books: $currentUser');
      return currentUser.savedBooks;
    } catch (e) {
      _logger.e('error returning booklist $e. user might be null');
      throw Exception('Exception thrown');
    }
  }

  void saveBook(Book book) async {
    try {
      Users? currentUser = await userRepo.getCurrentUserFromFirebase();
      currentUser?.savedBooks?.add(book);
      _logger.d('putting ${book.title} in the firebase');
      await usersCollection
          .doc(currentUser.userId)
          .update(currentUser.toDocument());
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
