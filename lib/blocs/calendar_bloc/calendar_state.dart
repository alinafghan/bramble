part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  final DateTime focusedDate;

  const CalendarState({required this.focusedDate});

  @override
  List<Object> get props => [focusedDate];
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded({required super.focusedDate});
}
