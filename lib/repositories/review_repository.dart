import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class ReviewRepository {
  final Logger _logger = Logger();

  final bookReviewCollection = FirebaseFirestore.instance.collection('Reviews');

  Future<Review> setReview(Review review, Book book) async {
    UserProvider provider = UserProvider();
    try {
      review.user = await provider.getCurrentUser();
      review.id = review.user.userId + review.book.bookId.toString();
      await bookReviewCollection.doc(review.id).set(review.toDocument());
      return review;
    } on SocketException {
      throw Exception('Please connect your wifi');
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Review?> getReview(Book book, String userId) async {
    try {
      String reviewId = book.bookId.toString() + userId;
      DocumentSnapshot doc = await bookReviewCollection.doc(reviewId).get();
      if (doc.exists) {
        return Review.fromDocument(doc.data() as Map<String, dynamic>);
      } else {
        _logger.e('Document does not exist'); // Document doesn't exist
      }
    } on SocketException {
      throw Exception('Please connect your wifi');
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<Review>> getReviewsForBook(Book book) async {
    try {
      QuerySnapshot snapshot = await bookReviewCollection
          .where("book.bookId",
              isEqualTo: book
                  .bookId) // Compare book ID inside the review's book object
          .get();

      List<Review> reviews = snapshot.docs.map((doc) {
        return Review.fromDocument(doc.data() as Map<String, dynamic>);
      }).toList();

      return reviews;
    } on SocketException {
      throw Exception('Please connect your WiFi');
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }
}
