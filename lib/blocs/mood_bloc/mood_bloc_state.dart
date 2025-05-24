part of 'mood_bloc.dart';

sealed class MoodBlocState extends Equatable {
  const MoodBlocState();

  @override
  List<Object> get props => [];
}

final class MoodBlocInitial extends MoodBlocState {}

final class GetMonthlyMoodsLoading extends MoodBlocState {}

final class GetMonthlyMoodsLoaded extends MoodBlocState {
  final Map<String, Mood>? moods;

  const GetMonthlyMoodsLoaded(this.moods);

  @override
  List<Object> get props => [moods!];
}

final class GetMonthlyMoodsFailed extends MoodBlocState {
  final String error;

  const GetMonthlyMoodsFailed(this.error);

  @override
  List<Object> get props => [error];
}

final class SetMoodLoading extends MoodBlocState {}

final class SetMoodLoaded extends MoodBlocState {
  final Mood mood;

  const SetMoodLoaded(this.mood);

  @override
  List<Object> get props => [mood];
}

final class SetMoodFailed extends MoodBlocState {
  final String error;

  const SetMoodFailed(this.error);

  @override
  List<Object> get props => [error];
}
