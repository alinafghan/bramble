part of 'review_cubit.dart';

class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

final class SetReviewInitial extends ReviewState {}

final class SetReviewLoading extends ReviewState {}

final class SetReviewFailure extends ReviewState {
  final String message;

  const SetReviewFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class SetReviewSuccess extends ReviewState {
  final Review review;

  const SetReviewSuccess(this.review);

  @override
  List<Object> get props => [review];
}

final class LikeReviewInitial extends ReviewState {}

final class LikeReviewLoading extends ReviewState {}

final class LikeReviewLoaded extends ReviewState {
  final Review review;

  const LikeReviewLoaded(this.review);

  @override
  List<Object> get props => [review];
}

final class LikeReviewFailure extends ReviewState {
  final String message;

  const LikeReviewFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class GetReviewForBookInitial extends ReviewState {}

final class GetReviewForBookLoading extends ReviewState {}

final class GetReviewForBookFailure extends ReviewState {
  final String message;

  const GetReviewForBookFailure(this.message);
  @override
  List<Object> get props => [message];
}

final class GetReviewForBookSuccess extends ReviewState {
  final List<Review?> reviews;

  const GetReviewForBookSuccess(this.reviews);

  @override
  List<Object> get props => [reviews];
}
