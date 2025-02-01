part of 'get_journal_bloc.dart';

@immutable
abstract class GetJournalState {}

class GetJournalFailure extends GetJournalState {}

class GetJournalLoading extends GetJournalState {}

class GetJournalSuccess extends GetJournalState {
  final Journal journal;

  GetJournalSuccess({required this.journal});
}
