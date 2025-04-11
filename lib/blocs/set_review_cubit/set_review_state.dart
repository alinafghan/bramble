part of 'set_review_cubit.dart';

class SetReviewState extends Equatable {
  const SetReviewState();

  @override
  List<Object> get props => [];
}

final class SetReviewInitial extends SetReviewState {}

final class SetReviewLoading extends SetReviewState {}

final class SetReviewFailure extends SetReviewState {
  final String message;

  const SetReviewFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class SetReviewSuccess extends SetReviewState {
  final Review review;

  const SetReviewSuccess(this.review);

  @override
  List<Object> get props => [review];
}

final class LikeReviewInitial extends SetReviewState {}

final class LikeReviewLoading extends SetReviewState {}

final class LikeReviewLoaded extends SetReviewState {
  final Review review;

  const LikeReviewLoaded(this.review);

  @override
  List<Object> get props => [review];
}

final class LikeReviewFailure extends SetReviewState {
  final String message;

  const LikeReviewFailure(this.message);

  @override
  List<Object> get props => [message];
}
