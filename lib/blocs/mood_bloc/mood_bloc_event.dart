part of 'mood_bloc.dart';

abstract class MoodBlocEvent extends Equatable {
  const MoodBlocEvent();

  @override
  List<Object> get props => [];
}

class SetMoodEvent extends MoodBlocEvent {
  final String moodAsset;
  final String date;

  const SetMoodEvent(this.date, this.moodAsset);

  @override
  List<Object> get props => [moodAsset, date];
}

class GetMonthlyMoodEvent extends MoodBlocEvent {
  final DateTime month;

  const GetMonthlyMoodEvent(this.month);

  @override
  List<Object> get props => [];
}

class DeleteMoodEvent extends MoodBlocEvent {
  final String date;

  const DeleteMoodEvent(this.date);

  @override
  List<Object> get props => [date];
}
