import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewProvider reviewProvider;
  List<Review?> _currentReviews = [];

  ReviewCubit({required this.reviewProvider}) : super(SetReviewInitial());

  void setReview(Review review, Book book) async {
    emit(SetReviewLoading());
    try {
      final result = await reviewProvider.setReview(book, review);
      if (result != null) {
        emit(SetReviewSuccess(result));
      } else {
        emit(const SetReviewFailure('Failed to set review'));
      }
    } catch (e) {
      emit(SetReviewFailure(e.toString()));
    }
  }

  void likeReview(Review review) async {
    emit(LikeReviewLoading());
    try {
      final result = await reviewProvider.likeReview(review);
      if (result != null) {
        final index = _currentReviews.indexWhere((r) => r?.id == result?.id);
        print(review);
        if (index != -1) {
          _currentReviews[index] = result;
        }
        print('check');
        emit(GetReviewForBookSuccess(_currentReviews));
      } else {
        emit(const LikeReviewFailure('Failed to like review'));
      }
    } catch (e) {
      emit(LikeReviewFailure(e.toString()));
    }
  }

  void getReviewForBook(Book book) async {
    emit(GetReviewForBookLoading());
    try {
      final result = await reviewProvider.getReviewsForBook(book);
      _currentReviews = result;
      emit(GetReviewForBookSuccess(result));
    } catch (e) {
      emit(GetReviewForBookFailure(e.toString()));
    }
  }

  void getReportedReviews() async {
    emit(GetReportedReviewsLoading());
    try {
      List<Review> reportedReviews = await reviewProvider.getReportedReviews();
      emit(GetReportedReviewsLoaded(reportedReviews: reportedReviews));
    } catch (e) {
      emit(GetReportedReviewsFailure(message: e.toString()));
    }
  }

  void reportReview(Review review, String reason) async {
    emit(ReportReviewLoading());
    try {
      await reviewProvider.reportReview(review, reason);
      emit(ReportedReviewLoaded(review: review));
    } catch (e) {
      emit(ReportedReviewFailure(message: e.toString()));
    }
  }

  void deleteReview(Review review) async {
    emit(DeleteReviewLoading());
    try {
      await reviewProvider.deleteReview(review);
      emit(DeleteReviewLoaded());
    } catch (e) {
      emit(DeleteReviewFailure(message: e.toString()));
    }
  }
}
