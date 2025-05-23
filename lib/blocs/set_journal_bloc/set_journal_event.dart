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

class AddImage extends SetJournalEvent {
  final Journal journal;
  final List<String> image;

  const AddImage({required this.journal, required this.image});

  @override
  List<Object> get props => [image];
}

class DeleteJournal extends SetJournalEvent {
  final String date;

  const DeleteJournal({required this.date});

  @override
  List<Object> get props => [date];
}
