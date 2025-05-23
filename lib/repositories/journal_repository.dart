import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/models/user.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:journal_app/repositories/user_repository.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class JournalRepository {
  final Logger _logger = Logger();
  final UserRepository _userRepository = UserRepository();

  final userJournalCollection =
      FirebaseFirestore.instance.collection('Journal');

  Future<Journal?> getJournalFromFirebase(String id) async {
    try {
      DocumentSnapshot doc = await userJournalCollection.doc(id).get();
      if (doc.exists) {
        return Journal.fromDocument(doc.data() as Map<String, dynamic>);
      } else {
        _logger.e('Document does not exist');
        return null; // Document doesn't exist
      }
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      return null; // Error while fetching the document
    }
  }

  Future<List<Journal>> getMonthlyJournal(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59); // End of month

    Users currentUser = await _userRepository.getCurrentUserFromFirebase();

    final snapshot = await userJournalCollection
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .where('user.userId', isEqualTo: currentUser.userId)
        .get();
    final journals = <Journal>[];
    for (var doc in snapshot.docs) {
      final journal = Journal.fromDocument(doc.data());
      journals.add(journal);
    }
    return journals;
  }

  Future<void> deleteJournal(String date) async {
    Users currUser = await _userRepository.getCurrentUserFromFirebase();
    String id = currUser.userId + date;
    print('Deleting journal with ID: $id');
    try {
      await userJournalCollection.doc(id).delete();
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('Error while deleting journal: $e');
      rethrow;
    }
  }

  Future<Journal> setJournal(Journal journal) async {
    UserProvider provider = UserProvider();

    try {
      journal.user = await provider.getCurrentUser();
      journal.id = journal.user.userId + journal.date;

      final docRef = userJournalCollection.doc(journal.id);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        // Update only the content and images fields
        await docRef.update({
          'content': journal.content,
          'images': journal.images,
          'updatedAt': FieldValue.serverTimestamp(), // optional
        });
      } else {
        // Create new document
        await docRef.set(journal.toDocument());
      }
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('Error while setting journal: $e');
      rethrow;
    }

    return journal;
  }

  Future<Journal> addImage(Journal journal, List<String> image) async {
    UserProvider provider = UserProvider();
    try {
      journal.user = await provider.getCurrentUser();
      journal.id = journal.user.userId + journal.date;
      journal.images = journal.images ?? [];
      journal.images!.addAll(image);
      await userJournalCollection.doc(journal.id).update(journal.toDocument());
      return journal;
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      _logger.e('Error while adding image: $e');
      rethrow;
    }
  }
}
