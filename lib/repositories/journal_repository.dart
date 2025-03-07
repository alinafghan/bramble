import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/providers/user_provider/user_provider.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class JournalRepository {
  final Logger _logger = Logger();

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

  Future<Journal> setJournal(Journal journal) async {
    UserProvider provider = UserProvider();
    try {
      journal.user = await provider.getCurrentUser();
      journal.id = journal.user.userId + journal.date;
      await userJournalCollection.doc(journal.id).set(journal.toDocument());
    } on SocketException {
      _logger.e('No internet connection. Check your Wi-Fi or mobile data.');
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      //log error
      _logger.e('Error while setting journal: $e');
      rethrow;
    }
    return journal;
  }
}
