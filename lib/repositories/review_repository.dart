import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class ReviewRepository {
  final Logger _logger = Logger();

  final bookReviewCollection = FirebaseFirestore.instance.collection('Reviews');
  final likeCollection = FirebaseFirestore.instance.collection('Likes');
  UserRepository userRepo = UserRepository();

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
        _logger.e('Document does not exist');
        return null; // Document doesn't exist
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

      final currentUser = await userRepo.getCurrentUserFromFirebase();

      for (final review in reviews) {
        final likeDoc = await FirebaseFirestore.instance
            .collection('Likes')
            .doc('${review.id}_${currentUser.userId}')
            .get();

        review.isLikedByCurrentUser = likeDoc.exists;
      }

      return reviews;
    } on SocketException {
      throw Exception('Please connect your WiFi');
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<Review> likeReview(Review review) async {
    try {
      Users? user = await userRepo.getCurrentUserFromFirebase();
      final likeDoc = likeCollection.doc('${review.id}_${user.userId}');
      final likeSnapshot = await likeDoc.get();
      final reviewDoc =
          FirebaseFirestore.instance.collection('Reviews').doc(review.id);

      if (likeSnapshot.exists) {
        // Already liked → UNLIKE
        await likeDoc.delete();
        review.numLikes = review.numLikes -= 1;
        await reviewDoc.update({
          'numLikes': FieldValue.increment(-1),
        });
      } else {
        // Not yet liked → LIKE
        await likeDoc.set({
          'userId': user.userId,
          'reviewId': review.id,
          'likedAt': DateTime.now(),
        });
        review.numLikes = review.numLikes += 1;
        await reviewDoc.update({
          'numLikes': FieldValue.increment(1),
        });
      }
      return review;
    } on SocketException {
      throw Exception('Please connect your wifi');
    } catch (e) {
      throw Exception('Error liking review: $e');
    }
  }
}
