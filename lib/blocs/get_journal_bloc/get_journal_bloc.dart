import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:meta/meta.dart';

part 'get_journal_event.dart';
part 'get_journal_state.dart';

class GetJournalBloc extends Bloc<GetJournalEvent, GetJournalState> {
  JournalProvider journalProvider = JournalProvider();

  GetJournalBloc({required JournalProvider provider})
      : journalProvider = provider,
        super(GetJournalLoading()) {
    on<GetJournal>((event, emit) async {
      emit(GetJournalLoading());
      try {
        Journal? journal = await journalProvider.getJournal(event.id);
        emit(GetJournalSuccess(journal: journal!));
      } catch (e) {
        emit(GetJournalFailure());
      }
    });
  }
}
