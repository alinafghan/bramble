import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_cubit_state.dart';

class TaskCubitCubit extends Cubit<TaskCubitState> {
  TaskCubitCubit() : super(TaskCubitInitial());

  void editTextfield() {
    emit(EditTextfieldOn());
  }

  void closeTextfield() {
    emit(EditTextfieldOff());
  }
}
