import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart'; // Update with correct path

void main() {
  group('FontCubit', () {
    test('initial state is "Dovemayo"', () {
      final cubit = FontCubit();
      expect(cubit.state, equals('Dovemayo'));
    });

    blocTest<FontCubit, String>(
      'emits new font when changeFont is called',
      build: () => FontCubit(),
      act: (cubit) => cubit.changeFont('Roboto'),
      expect: () => ['Roboto'],
    );

    blocTest<FontCubit, String>(
      'emits multiple font changes in order',
      build: () => FontCubit(),
      act: (cubit) {
        cubit.changeFont('Roboto');
        cubit.changeFont('Lato');
      },
      expect: () => ['Roboto', 'Lato'],
    );
  });
  group('FontState', () {
    test('FontInitial is a subclass of FontState', () {
      expect(FontInitial(), isA<FontState>());
    });

    test('FontInitial props are empty', () {
      expect(FontInitial().props, equals([]));
    });

    test('FontInitial supports value equality', () {
      expect(FontInitial(), equals(FontInitial()));
    });
  });
}
