import 'package:journal_app/models/journal.dart';
import 'package:journal_app/repositories/journal_repository.dart';

class JournalProvider {
  final JournalRepository _journalRepository = JournalRepository();

  Future<Journal?> getJournal(String id) async {
    Journal? entry = await _journalRepository.getJournalFromFirebase(id);
    return entry;
  }

  Future<Journal> setJournal(Journal entry) async {
    entry = await _journalRepository.setJournal(entry);
    return entry;
  }
}
