import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewProvider reviewProvider;

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
      final result =
          await reviewProvider.likeReview(review); //sends back updated review
      if (result != null) {
        emit(SetReviewSuccess(result)); //testing
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
      emit(GetReviewForBookSuccess(result));
    } catch (e) {
      emit(GetReviewForBookFailure(e.toString()));
    }
  }
}
