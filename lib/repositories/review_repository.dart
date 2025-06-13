import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/report.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class ReviewRepository {
  final Logger _logger = Logger();
  AuthRepository userRepo;
  final FirebaseFirestore _firestore;

  ReviewRepository({AuthRepository? repo, FirebaseFirestore? firestore})
      : userRepo = repo ?? AuthRepository(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get bookReviewCollection =>
      _firestore.collection('Reviews');
  CollectionReference get likeCollection => _firestore.collection('Likes');

  Future<void> deleteReview(Review review) async {
    try {
      // Delete the review document
      await bookReviewCollection.doc(review.id).delete();
      // Delete associated likes (if any)
      final likeQuery =
          await likeCollection.where('reviewId', isEqualTo: review.id).get();

      for (final doc in likeQuery.docs) {
        await doc.reference.delete();
      }
      _logger.i('Review and associated likes deleted successfully.');
    } on SocketException {
      throw Exception('Please connect your WiFi');
    } catch (e) {
      throw Exception('Error deleting review: $e');
    }
  }

  Future<Review> setReview(Review review, Book book) async {
    try {
      review.user = await userRepo.getCurrentUser();
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
        final likeDoc = await _firestore
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
      final reviewDoc = _firestore.collection('Reviews').doc(review.id);

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
      if (review.isLikedByCurrentUser == true) {
        review.isLikedByCurrentUser = false;
      } else {
        review.isLikedByCurrentUser = true;
      }
      return review;
    } on SocketException {
      throw Exception('Please connect your wifi');
    } catch (e) {
      throw Exception('Error liking review: $e');
    }
  }

  Future<List<Review>> getReportedReviews() async {
    try {
      QuerySnapshot snapshot = await bookReviewCollection.get();

      List<Review> reportedReviews = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if reports field exists and is not empty
        if (data.containsKey('reports') &&
            data['reports'] is List &&
            (data['reports'] as List).isNotEmpty) {
          Review review = Review.fromDocument(data);
          reportedReviews.add(review);
        }
      }

      return reportedReviews;
    } on SocketException {
      throw Exception('Please connect your WiFi');
    } catch (e) {
      throw Exception('Error fetching reported reviews: $e');
    }
  } // for formatting date

  Future<void> reportReview({
    required Review review,
    required String reason,
  }) async {
    try {
      Users currentUser = await userRepo.getCurrentUserFromFirebase();

      // Create a new report object
      Report newReport = Report(
        user: currentUser,
        reason: reason,
        reportedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      DocumentReference reviewDocRef = bookReviewCollection.doc(review.id);
      DocumentSnapshot docSnapshot = await reviewDocRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Review not found.');
      }

      // Get current reports list or empty
      List<dynamic> existingReports =
          (docSnapshot.data() as Map<String, dynamic>)['reports'] ?? [];

      // Add new report
      existingReports.add(newReport.toMap());

      // Update Firestore document
      await reviewDocRef.update({
        'reports': existingReports,
      });
    } on SocketException {
      throw Exception('Please connect your WiFi');
    } catch (e) {
      throw Exception('Error reporting review: $e');
    }
  }
}
