import 'package:journal_app/models/journal.dart';
import 'package:journal_app/repositories/journal_repository.dart';

class JournalProvider {
  final JournalRepository _journalRepository = JournalRepository();

  Future<Journal?> getJournal(String id) async {
    Journal? entry = await _journalRepository.getJournalFromFirebase(id);
    return entry;
  }

  Future<void> deleteJournal(String date) async {
    await _journalRepository.deleteJournal(date);
  }

  Future<Journal> setJournal(Journal entry) async {
    entry = await _journalRepository.setJournal(entry);
    return entry;
  }

  Future<List<Journal>> getMonthlyJournal(DateTime month) async {
    List<Journal> monthlyJournals =
        await _journalRepository.getMonthlyJournal(month);
    return monthlyJournals;
  }

  Future<Journal> addImage(Journal journal, List<String> image) async {
    Journal entry = await _journalRepository.addImage(journal, image);
    return entry;
  }
}
