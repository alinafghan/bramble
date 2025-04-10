import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/models/review.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';

part 'get_review_for_book_state.dart';

class GetReviewForBookCubit extends Cubit<GetReviewForBookState> {
  ReviewProvider reviewProvider = ReviewProvider();
  GetReviewForBookCubit({required ReviewProvider provider})
      : reviewProvider = provider,
        super(GetReviewForBookInitial());

  void getReviewForBook(Book book) async {
    emit(GetReviewForBookLoading());
    try {
      final result = await reviewProvider.getReviewsForBook(book);
      if (result != null) {
        emit(GetReviewForBookSuccess(result));
      } else {
        emit(GetReviewForBookFailure('Failed to get reviews'));
      }
    } catch (e) {
      emit(GetReviewForBookFailure(e.toString()));
    }
  }
}
