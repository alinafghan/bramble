part of 'get_journal_bloc.dart';

@immutable
class GetJournalEvent extends Equatable {
  const GetJournalEvent();

  @override
  List<Object?> get props => [];
}

class GetJournal extends GetJournalEvent {
  final String id;

  const GetJournal({required this.id});

  @override
  List<Object?> get props => [id];
}
