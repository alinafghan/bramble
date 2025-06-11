import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';

void main() {
  group('Mood model', () {
    final testUser = Users(
      userId: 'user123',
      username: 'Alina',
      email: 'alina@example.com',
      mod: false,
      profileUrl: 'https://example.com/profile.jpg',
    );

    final mood = Mood(
      date: '2025-06-10',
      mood: 'happy_face.png',
      user: testUser,
    );

    test('toJson returns correct map', () {
      final json = mood.toJson();
      expect(json['date'], '2025-06-10');
      expect(json['moodAsset'], 'happy_face.png');
      expect(json['user']['userId'], 'user123');
      expect(json['user']['username'], 'Alina');
    });

    test('fromJson creates correct Mood object', () {
      final jsonMap = {
        'date': '2025-06-10',
        'moodAsset': 'happy_face.png',
        'user': {
          'userId': 'user123',
          'username': 'Alina',
          'email': 'alina@example.com',
          'mod': false,
          'profileUrl': 'https://example.com/profile.jpg',
          'savedBooks': [],
        },
      };

      final parsedMood = Mood.fromJson(jsonMap);
      expect(parsedMood.date, '2025-06-10');
      expect(parsedMood.mood, 'happy_face.png');
      expect(parsedMood.user.email, 'alina@example.com');
    });
  });
}
