import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarLoaded(focusedDate: DateTime.now())) {
    on<ChangeFocusedMonth>((event, emit) {
      emit(CalendarLoaded(focusedDate: event.newFocusedMonth));
    });
  }
}
