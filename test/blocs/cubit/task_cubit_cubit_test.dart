import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';

void main() {
  group('ReviewCubit Tests', () {
    blocTest<TaskCubitCubit, TaskCubitState>('test the task cubit',
        build: () => TaskCubitCubit(),
        act: (cubit) => cubit.editTextfield(),
        expect: () => [EditTextfieldOn()]);

    blocTest<TaskCubitCubit, TaskCubitState>(
        'test the task cubit closing text field',
        build: () => TaskCubitCubit(),
        act: (cubit) => cubit.closeTextfield(),
        expect: () => [EditTextfieldOff()]);
    // Add your tests here
  });
}
