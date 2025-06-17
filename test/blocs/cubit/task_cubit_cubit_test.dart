import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';

void main() {
  group('TaskCubitCubit Tests', () {
    blocTest<TaskCubitCubit, TaskCubitState>(
      'emits EditTextfieldOn when editTextfield is called',
      build: () => TaskCubitCubit(),
      act: (cubit) => cubit.editTextfield(),
      expect: () => [EditTextfieldOn()],
    );

    blocTest<TaskCubitCubit, TaskCubitState>(
      'emits EditTextfieldOff when closeTextfield is called',
      build: () => TaskCubitCubit(),
      act: (cubit) => cubit.closeTextfield(),
      expect: () => [EditTextfieldOff()],
    );

    blocTest<TaskCubitCubit, TaskCubitState>(
      'toggleExpand should expand the given key',
      build: () => TaskCubitCubit(),
      act: (cubit) => cubit.toggleExpand('entry1'),
      expect: () => [
        const ToggleExpandState({'entry1': true})
      ],
    );

    blocTest<TaskCubitCubit, TaskCubitState>(
      'toggleExpand should collapse an already expanded key',
      build: () =>
          TaskCubitCubit()..toggleExpand('entry1'), // manually expand first
      act: (cubit) => cubit.toggleExpand('entry1'),
      expect: () => [
        const ToggleExpandState({'entry1': false})
      ],
    );

    test('isExpanded should return true only if the key was expanded', () {
      final cubit = TaskCubitCubit();
      expect(cubit.isExpanded('entry1'), false);
      cubit.toggleExpand('entry1');
      expect(cubit.isExpanded('entry1'), true);
      cubit.toggleExpand('entry1');
      expect(cubit.isExpanded('entry1'), false);
    });
  });
  group('ToggleExpandState', () {
    test('stores expanded map correctly', () {
      final map = {'key1': true, 'key2': false};
      final state = ToggleExpandState(map);

      expect(state.expanded, equals(map));
    });

    test('supports value equality', () {
      final map1 = {'key1': true};
      final map2 = {'key1': true};

      final state1 = ToggleExpandState(map1);
      final state2 = ToggleExpandState(map2);

      expect(state1, equals(state2));
    });

    test('inequality for different maps', () {
      const state1 = ToggleExpandState({'a': true});
      const state2 = ToggleExpandState({'a': false});

      expect(state1 == state2, isFalse);
    });
  });
  group('GetBookDetailsLoading', () {
    test('supports value comparison', () {
      expect(GetBookDetailsLoading(), GetBookDetailsLoading());
    });

    test('props are empty', () {
      expect(GetBookDetailsLoading().props, []);
    });
  });
}
