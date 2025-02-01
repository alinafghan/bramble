import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarLoaded(focusedDate: DateTime.now())) {
    on<ChangeFocusedMonth>((event, emit) {
      emit(CalendarLoaded(focusedDate: event.newFocusedMonth));
    });
  }
}
