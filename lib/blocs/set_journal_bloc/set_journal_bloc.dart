import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:meta/meta.dart';

part 'set_journal_event.dart';
part 'set_journal_state.dart';

class SetJournalBloc extends Bloc<SetJournalEvent, SetJournalState> {
  JournalProvider journalProvider = JournalProvider();

  SetJournalBloc({required JournalProvider provider})
      : journalProvider = provider,
        super(SetJournalLoading()) {
    on<SetJournal>((event, emit) async {
      emit(SetJournalLoading());
      try {
        Journal entry = await journalProvider.setJournal(event.journal);
        emit(SetJournalSuccess(journal: entry));
      } catch (e) {
        emit(SetJournalFailure());
      }
    });
  }
}
