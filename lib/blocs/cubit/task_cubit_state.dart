part of 'task_cubit_cubit.dart';

abstract class TaskCubitState extends Equatable {
  const TaskCubitState();

  @override
  List<Object> get props => [];
}

final class TaskCubitInitial extends TaskCubitState {}

final class EditTextfieldLoading extends TaskCubitState {}

final class EditTextfieldOn extends TaskCubitState {}

final class EditTextfieldOff extends TaskCubitState {}

class ToggleExpandState extends TaskCubitState {
  final Map<String, bool> expanded;

  const ToggleExpandState(this.expanded);

  @override
  List<Object> get props => [expanded];
}
