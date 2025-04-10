import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';

part 'set_review_state.dart';

class SetReviewCubit extends Cubit<SetReviewState> {
  ReviewProvider reviewProvider = ReviewProvider();

  SetReviewCubit({required ReviewProvider provider})
      : reviewProvider = provider,
        super(SetReviewInitial());

  void setReview(Review review, Book book) async {
    emit(SetReviewLoading());
    try {
      final result = await reviewProvider.setReview(book, review);
      if (result != null) {
        emit(SetReviewSuccess(result));
      } else {
        emit(SetReviewFailure('Failed to set review'));
      }
    } catch (e) {
      emit(SetReviewFailure(e.toString()));
    }
  }
}
