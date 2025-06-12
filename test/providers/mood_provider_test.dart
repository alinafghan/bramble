import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/mood_provider/mood_provider.dart';
import 'package:journal_app/repositories/mood_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMoodRepository extends Mock implements MoodRepository {}

void main() {
  late MockMoodRepository mockRepo;
  late MoodProvider provider;
  late Mood testMood;

  setUp(() {
    mockRepo = MockMoodRepository();
    provider = MoodProvider(repo: mockRepo);
    testMood = Mood(
      date: '2025-06-12',
      mood: 'assets/happy.png',
      user: Users(
          userId: '',
          email: 'a@gmail',
          mod: false), // If needed, you can mock a user as well
    );
  });

  group('MoodProvider Tests', () {
    test('setMood returns mood', () async {
      when(() => mockRepo.setMood(testMood.mood, testMood.date))
          .thenAnswer((_) async => testMood);

      final result = await provider.setMood(testMood.mood, testMood.date);

      expect(result, equals(testMood));
      verify(() => mockRepo.setMood(testMood.mood, testMood.date)).called(1);
    });

    test('getMood returns monthly mood map', () async {
      final month = DateTime(2025, 6);
      final moods = {testMood.date: testMood};

      when(() => mockRepo.getMood(month)).thenAnswer((_) async => moods);

      final result = await provider.getMood(month);

      expect(result, equals(moods));
      verify(() => mockRepo.getMood(month)).called(1);
    });

    test('deleteMood calls repository method', () async {
      when(() => mockRepo.deleteMood(testMood.date)).thenAnswer((_) async {});

      await provider.deleteMood(testMood.date);

      verify(() => mockRepo.deleteMood(testMood.date)).called(1);
    });
  });
}
