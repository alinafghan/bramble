import 'package:journal_app/models/mood.dart';
import 'package:journal_app/repositories/mood_repository.dart';

class MoodProvider {
  final MoodRepository _moodRepository;

  MoodProvider({MoodRepository? repo})
      : _moodRepository = repo ?? MoodRepository();

  Future<Mood> setMood(String moodAsset, String date) async {
    return _moodRepository.setMood(moodAsset, date);
  }

  Future<Map<String, Mood>?> getMood(DateTime month) async {
    return _moodRepository.getMood(month);
  }

  Future<void> deleteMood(String date) async {
    return _moodRepository.deleteMood(date);
  }
}
