import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class BookListRepository {
  final Logger _logger = Logger();
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  UserRepository userRepo = UserRepository();
  FirebaseAuthRepository repo = FirebaseAuthRepository();

  Future<List<Book>?> returnBookList() async {
    try {
      Users currentUser = await userRepo.getCurrentUserFromFirebase();

      DocumentSnapshot result =
          await usersCollection.doc(currentUser.userId).get();

      Users newUser = Users.fromDocument(result.data() as Map<String, dynamic>);

      return newUser.savedBooks;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error returning booklist $e. user might be null');
      throw Exception('Exception thrown');
    }
  }

  void saveBook(Book book) async {
    try {
      _logger.d(book);
      Users? currentUser = await userRepo.getCurrentUserFromFirebase();

      if (currentUser.savedBooks!.contains(book)) {
        print('this book already in the list');
        return;
      }

      currentUser?.savedBooks?.add(book);

      await usersCollection
          .doc(currentUser.userId)
          .update(currentUser.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error saving book $e');
    }
  }

  void removeBook(Book book) async {
    try {
      Users? currentUser = await userRepo.getCurrentUserFromFirebase();
      currentUser.savedBooks?.remove(book);
      await usersCollection
          .doc(currentUser.userId)
          .update(currentUser.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('error deleting book $e');
    }
  }
}
