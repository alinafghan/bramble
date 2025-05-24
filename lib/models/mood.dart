import 'package:journal_app/models/user.dart';

class Mood {
  final String date;
  final String mood;
  final Users user;

  Mood({required this.date, required this.mood, required this.user});

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      date: (json['date']),
      mood: json['moodAsset'],
      user: Users.fromDocument(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'moodAsset': mood,
      'user': user.toDocument(),
    };
  }
}
