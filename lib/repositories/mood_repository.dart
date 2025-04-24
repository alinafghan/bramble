import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/mood.dart';
import 'package:logger/logger.dart';

class MoodRepository {
  final Logger _logger = Logger();
  final bookReviewCollection = FirebaseFirestore.instance
      .collection('Moods'); // Placeholder for the mood image

  void setMood(Mood mood) async {
    try {
      await bookReviewCollection
          .doc(mood.date.toIso8601String())
          .set(mood.toJson());
    } catch (e) {
      _logger.e('Error setting mood: $e');
    }
  }

  Future<Map<DateTime, Mood>?> getMood(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    print(month.month);
    final end =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59); // End of month

    final snapshot = await bookReviewCollection
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .get();

    print(snapshot);

    final moods = <DateTime, Mood>{};
    for (var doc in snapshot.docs) {
      final mood = Mood.fromJson(doc.data());
      final normalized =
          DateTime(mood.date.year, mood.date.month, mood.date.day);
      moods[normalized] = mood;
    }

    print('Moods for the month: $month');
    print('Moods: $moods');
    return moods;
  }
}
