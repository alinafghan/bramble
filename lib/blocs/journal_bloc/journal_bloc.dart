import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:meta/meta.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalProvider journalProvider;

  JournalBloc({required this.journalProvider}) : super(SetJournalLoading()) {
    on<SetJournal>((event, emit) async {
      emit(SetJournalLoading());
      try {
        Journal entry = await journalProvider.setJournal(event.journal);
        emit(SetJournalSuccess(journal: entry));
      } catch (e) {
        emit(SetJournalFailure());
      }
    });
    on<AddImage>((event, emit) async {
      emit(SetJournalLoading());
      try {
        Journal entry =
            await journalProvider.addImage(event.journal, event.image);
        emit(SetJournalSuccess(journal: entry));
      } catch (e) {
        emit(SetJournalFailure());
      }
    });
    on<DeleteJournal>((event, emit) async {
      emit(DeleteJournalLoading());
      try {
        await journalProvider.deleteJournal(event.date);
        emit(DeleteJournalSuccess());
      } catch (e) {
        emit(DeleteJournalFailure());
      }
    });
    on<GetJournal>((event, emit) async {
      emit(GetJournalLoading());
      try {
        Journal? journal = await journalProvider.getJournal(event.id);
        emit(GetJournalSuccess(journal: journal!));
      } catch (e) {
        emit(GetJournalFailure());
      }
    });
    on<GetMonthlyJournal>((event, emit) async {
      emit(GetMonthlyJournalLoading());
      try {
        List<Journal> journal =
            await journalProvider.getMonthlyJournal(event.month);
        emit(GetMonthlyJournalSuccess(journals: journal));
      } catch (e) {
        emit(GetMonthlyJournalError());
      }
    });
  }
}
