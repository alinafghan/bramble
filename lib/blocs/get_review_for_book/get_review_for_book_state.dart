part of 'get_review_for_book_cubit.dart';

class GetReviewForBookState extends Equatable {
  const GetReviewForBookState();

  @override
  List<Object> get props => [];
}

final class GetReviewForBookInitial extends GetReviewForBookState {}

final class GetReviewForBookLoading extends GetReviewForBookState {}

final class GetReviewForBookFailure extends GetReviewForBookState {
  final String message;

  const GetReviewForBookFailure(this.message);
  @override
  List<Object> get props => [message];
}

final class GetReviewForBookSuccess extends GetReviewForBookState {
  final List<Review?> reviews;

  const GetReviewForBookSuccess(this.reviews);

  @override
  List<Object> get props => [reviews];
}
