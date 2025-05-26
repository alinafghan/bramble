part of 'journal_bloc.dart';

class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

final class SetJournalLoading extends JournalState {}

final class SetJournalFailure extends JournalState {}

final class SetJournalSuccess extends JournalState {
  final Journal journal;

  const SetJournalSuccess({required this.journal});

  @override
  List<Object> get props => [journal];
}

final class DeleteJournalLoading extends JournalState {}

final class DeleteJournalFailure extends JournalState {}

final class DeleteJournalSuccess extends JournalState {
  @override
  List<Object> get props => [];
}

class GetJournalFailure extends JournalState {}

class GetJournalLoading extends JournalState {}

class GetJournalSuccess extends JournalState {
  final Journal journal;

  const GetJournalSuccess({required this.journal});
}

class GetMonthlyJournalLoading extends JournalState {}

class GetMonthlyJournalError extends JournalState {}

class GetMonthlyJournalSuccess extends JournalState {
  final List<Journal> journals;

  const GetMonthlyJournalSuccess({required this.journals});
}
