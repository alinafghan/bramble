import 'package:journal_app/models/user.dart';

class Mood {
  final DateTime date;
  final String mood;
  final Users user;

  Mood({required this.date, required this.mood, required this.user});

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      date: DateTime.parse(json['date']),
      mood: json['moodAsset'],
      user: Users.fromDocument(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'moodAsset': mood,
      'user': user.toDocument(),
    };
  }
}
