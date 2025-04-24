part of 'mood_bloc.dart';

abstract class MoodBlocEvent extends Equatable {
  const MoodBlocEvent();

  @override
  List<Object> get props => [];
}

class SetMoodEvent extends MoodBlocEvent {
  final Mood mood;

  const SetMoodEvent(this.mood);

  @override
  List<Object> get props => [mood];
}

class GetMonthlyMoodEvent extends MoodBlocEvent {
  final DateTime month;

  const GetMonthlyMoodEvent(this.month);

  @override
  List<Object> get props => [];
}
