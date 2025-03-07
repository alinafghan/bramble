part of 'set_journal_bloc.dart';

@immutable
abstract class SetJournalEvent extends Equatable {
  const SetJournalEvent();

  @override
  List<Object> get props => [];
}

class SetJournal extends SetJournalEvent {
  final Journal journal;

  const SetJournal({required this.journal});

  @override
  List<Object> get props => [journal];
}
