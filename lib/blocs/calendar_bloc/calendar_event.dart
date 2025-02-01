part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class ChangeFocusedMonth extends CalendarEvent {
  final DateTime newFocusedMonth;

  const ChangeFocusedMonth(this.newFocusedMonth);

  @override
  List<Object> get props => [newFocusedMonth];
}
