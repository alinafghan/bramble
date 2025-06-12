import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/review_repository.dart';

class ReviewProvider {
  final ReviewRepository reviewRepository;

  ReviewProvider({ReviewRepository? repo})
      : reviewRepository = repo ?? ReviewRepository();

  Future<List<Review?>> getReviewsForBook(Book book) async {
    return reviewRepository.getReviewsForBook(book);
  }

  Future<Review?> getReview(Book book, Users user) async {
    return reviewRepository.getReview(book, user.userId);
  }

  Future<Review?> setReview(Book book, Review review) async {
    return reviewRepository.setReview(review, book);
  }

  Future<Review?> likeReview(Review review) async {
    return reviewRepository.likeReview(review);
  }
}
