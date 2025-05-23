import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:logger/logger.dart';

class MoodRepository {
  final Logger _logger = Logger();
  final bookReviewCollection = FirebaseFirestore.instance.collection('Moods');
  UserRepository userRepo = UserRepository();

  Future<Mood> setMood(String moodAsset, DateTime date) async {
    Users currentUser = await userRepo.getCurrentUserFromFirebase();
    Mood mood = Mood(
      date: date,
      mood: moodAsset,
      user: currentUser, // Placeholder for the user
    );
    try {
      await bookReviewCollection
          .doc(mood.date.toIso8601String() + currentUser.userId)
          .set(mood.toJson());
      return mood;
    } catch (e) {
      _logger.e('Error setting mood: $e');
      throw Exception('Error setting mood: $e');
    }
  }

  Future<Map<DateTime, Mood>?> getMood(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59); // End of month

    Users currentUser = await userRepo.getCurrentUserFromFirebase();

    final snapshot = await bookReviewCollection
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .where('user.userId', isEqualTo: currentUser.userId)
        .get();

    final moods = <DateTime, Mood>{};
    for (var doc in snapshot.docs) {
      final mood = Mood.fromJson(doc.data());
      final normalized =
          DateTime(mood.date.year, mood.date.month, mood.date.day);
      moods[normalized] = mood;
    }
    return moods;
  }
}
