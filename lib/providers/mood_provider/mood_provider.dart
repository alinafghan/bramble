import 'package:journal_app/models/mood.dart';
import 'package:journal_app/repositories/mood_repository.dart';

class MoodProvider {
  final MoodRepository _moodRepository = MoodRepository();

  Future<void> setMood(Mood mood) async {
    _moodRepository.setMood(mood);
  }

  Future<Map<DateTime, Mood>?> getMood(DateTime month) async {
    return _moodRepository.getMood(month);
  }
}
