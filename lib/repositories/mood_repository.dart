import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/mood.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:logger/logger.dart';

class MoodRepository {
  final Logger _logger = Logger();
  AuthRepository userRepo;
  final FirebaseFirestore _firestore;

  MoodRepository({AuthRepository? repo, FirebaseFirestore? firestore})
      : userRepo = repo ?? AuthRepository(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get bookReviewCollection =>
      _firestore.collection('Moods');

  Future<Mood> setMood(String moodAsset, String date) async {
    Users currentUser = await userRepo.getCurrentUserFromFirebase();
    Mood mood = Mood(
      date: date,
      mood: moodAsset,
      user: currentUser, // Placeholder for the user
    );
    try {
      await bookReviewCollection
          .doc(mood.date + currentUser.userId)
          .set(mood.toJson());
      return mood;
    } catch (e) {
      _logger.e('Error setting mood: $e');
      throw Exception('Error setting mood: $e');
    }
  }

  Future<void> deleteMood(String date) async {
    Users currentUser = await userRepo.getCurrentUserFromFirebase();
    try {
      await bookReviewCollection.doc(date + currentUser.userId).delete();
    } catch (e) {
      _logger.e('Error deleting mood: $e');
      throw Exception('Error deleting mood: $e');
    }
  }

  Future<Map<String, Mood>?> getMood(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59); // End of month

    try {
      Users currentUser = await userRepo.getCurrentUserFromFirebase();

      final snapshot = await bookReviewCollection
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThanOrEqualTo: end.toIso8601String())
          .where('user.userId', isEqualTo: currentUser.userId)
          .get();

      final moods = <String, Mood>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final mood = Mood.fromJson(data as Map<String, dynamic>);
        moods[mood.date] = mood;
      }
      return moods;
    } catch (e) {
      _logger.e('Error getting monthly mood: $e');
      throw Exception('Error getting monthly mood: $e');
    }
  }
}
