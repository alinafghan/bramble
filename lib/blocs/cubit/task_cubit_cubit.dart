import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_cubit_state.dart';

class TaskCubitCubit extends Cubit<TaskCubitState> {
  TaskCubitCubit() : super(TaskCubitInitial());

  void editTextfield() {
    emit(EditTextfieldOn());
  }
}
