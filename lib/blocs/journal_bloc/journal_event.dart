part of 'journal_bloc.dart';

@immutable
abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

class SetJournal extends JournalEvent {
  final Journal journal;

  const SetJournal({required this.journal});

  @override
  List<Object> get props => [journal];
}

class AddImage extends JournalEvent {
  final Journal journal;
  final List<String> image;

  const AddImage({required this.journal, required this.image});

  @override
  List<Object> get props => [image];
}

class DeleteJournal extends JournalEvent {
  final String date;

  const DeleteJournal({required this.date});

  @override
  List<Object> get props => [date];
}

class GetJournal extends JournalEvent {
  final String id;

  const GetJournal({required this.id});

  @override
  List<Object> get props => [id];
}

class GetMonthlyJournal extends JournalEvent {
  final DateTime month;

  const GetMonthlyJournal({required this.month});

  @override
  List<Object> get props => [month];
}

class ClearJournalEvent extends JournalEvent {
  @override
  List<Object> get props => [];
}
