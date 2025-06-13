import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_cubit_state.dart';

class TaskCubitCubit extends Cubit<TaskCubitState> {
  TaskCubitCubit() : super(TaskCubitInitial());
  final Map<String, bool> _expandedMap = {};

  void editTextfield() {
    emit(EditTextfieldOn());
  }

  void closeTextfield() {
    emit(EditTextfieldOff());
  }

  void toggleExpand(String key) {
    _expandedMap[key] = !(_expandedMap[key] ?? false);
    emit(ToggleExpandState({..._expandedMap}));
  }

  bool isExpanded(String key) {
    return _expandedMap[key] ?? false;
  }
}
