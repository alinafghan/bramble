import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class BookRepository {
  final userBookCollection = FirebaseFirestore.instance.collection('Library');
  final Logger _logger = Logger();

  Future<Book?> getBookFromFirebase(String bookId) async {
    try {
      DocumentSnapshot doc = await userBookCollection.doc(bookId).get();
      Book book = Book.fromDocument(doc.data() as Map<String, dynamic>);
      return book;
    } catch (e) {
      _logger.e(
          'Error while fetching one book from firebase'); // Error while fetching the document
    }
    return null;
  }

  Future<List<Book>> getLibraryFromFirebase(String userId) async {
    try {
      var querySnapshot =
          await userBookCollection.where('userId', isEqualTo: userId).get();

      List<Book> books = querySnapshot.docs
          .map((doc) => Book.fromDocument(doc.data()))
          .toList();

      return books;
    } catch (e) {
      _logger.e('Error while fetching the library from firebase.');
      return [];
    }
  }

  Future<void> setBook(Book book) async {
    UserProvider provider = UserProvider();
    try {
      book.user = await provider.getCurrentUser();
      book.userId = book.user.userId;
      book.dateAdded = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      book.bookId = const Uuid().v1();
      await userBookCollection
          .doc(book.user.userId + book.bookId)
          .set(book.toDocument());
    } catch (e) {
      _logger.e('Error while setting the book.');
      return;
    }
  }

  Future<void> deleteBook(String userId, String bookId) async {
    try {
      await userBookCollection.doc(userId + bookId).delete();
    } catch (e) {
      _logger.e('Error while deleting the book: $e');
      return;
    }
  }
}
