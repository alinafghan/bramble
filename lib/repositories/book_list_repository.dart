import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class BookListRepository {
  final Logger _logger = Logger();
  final CollectionReference usersCollection;
  final AuthRepository repo;

  BookListRepository({
    CollectionReference? usersCollection,
    AuthRepository? repo,
  })  : usersCollection =
            usersCollection ?? FirebaseFirestore.instance.collection('Users'),
        repo = repo ?? AuthRepository();

  Future<List<Book>?> returnBookList() async {
    try {
      Users currentUser = await repo.getCurrentUserFromFirebase();

      DocumentSnapshot result =
          await usersCollection.doc(currentUser.userId).get();

      Users newUser = Users.fromDocument(result.data() as Map<String, dynamic>);

      return newUser.savedBooks;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      rethrow;
    } catch (e) {
      _logger.e('error returning booklist $e. user might be null');
      throw Exception('Exception thrown');
    }
  }

  Future<void> saveBook(Book book) async {
    try {
      _logger.d(book);
      Users? currentUser = await repo.getCurrentUserFromFirebase();

      if (currentUser.savedBooks!.contains(book)) {
        _logger.d('this book already in the list');
        return;
      }

      currentUser.savedBooks?.add(book);

      await usersCollection
          .doc(currentUser.userId)
          .update(currentUser.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error saving book $e');
      throw Exception('Unexpected error occurred while saving the book');
    }
  }

  Future<void> removeBook(Book book) async {
    try {
      Users? currentUser = await repo.getCurrentUserFromFirebase();
      currentUser.savedBooks?.remove(book);
      await usersCollection
          .doc(currentUser.userId)
          .update(currentUser.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error deleting book $e');
      throw Exception('Unexpected error occurred while removing the book');
    }
  }
}
