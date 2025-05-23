import 'package:journal_app/models/mood.dart';
import 'package:journal_app/repositories/mood_repository.dart';

class MoodProvider {
  final MoodRepository _moodRepository = MoodRepository();

  Future<Mood> setMood(String moodAsset, DateTime date) async {
    return _moodRepository.setMood(moodAsset, date);
  }

  Future<Map<DateTime, Mood>?> getMood(DateTime month) async {
    return _moodRepository.getMood(month);
  }
}
