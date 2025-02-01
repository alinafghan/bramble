part of 'set_journal_bloc.dart';

class SetJournalState extends Equatable {
  const SetJournalState();

  @override
  List<Object> get props => [];
}

final class SetJournalLoading extends SetJournalState {}

final class SetJournalFailure extends SetJournalState {}

final class SetJournalSuccess extends SetJournalState {
  final Journal journal;

  const SetJournalSuccess({required this.journal});

  @override
  List<Object> get props => [journal];
}
