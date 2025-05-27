import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/calendar_bloc/calendar_bloc.dart';

void main() {
  group('calendar bloctests', () {
    final DateTime testDate = DateTime(2023, 10, 1);

    blocTest<CalendarBloc, CalendarState>('',
        build: () => CalendarBloc(),
        act: (bloc) => bloc.add(ChangeFocusedMonth(testDate)),
        expect: () => <CalendarState>[CalendarLoaded(focusedDate: testDate)]);
    // Add your tests here
  });
}
