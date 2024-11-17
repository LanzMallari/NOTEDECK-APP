import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notedeck');

  // Create (Add a new note)
  Future<void> addNote(Map<String, String> note, {bool isFavorite = false}) async {
    try {
      await notes.add({
        'title': note['title'] ?? 'Untitled',
        'description': note['description'] ?? '',
        'timestamp': Timestamp.now(),
        'isFavorite': isFavorite,  // Add the isFavorite field
      });
    } catch (e) {
      print("Error adding note: $e");
      rethrow;
    }
  }

  // Read (Stream all notes)
  Stream<QuerySnapshot> getNotesStream() {
    try {
      return notes.orderBy('timestamp', descending: true).snapshots();
    } catch (e) {
      print("Error getting notes stream: $e");
      rethrow;
    }
  }

  // Read (Stream only favorite notes)
  Stream<QuerySnapshot> getFavoriteNotesStream() {
    try {
      return notes.where('isFavorite', isEqualTo: true).orderBy('timestamp', descending: true).snapshots();
    } catch (e) {
      print("Error getting favorite notes stream: $e");
      rethrow;
    }
  }

  // Update (Modify an existing note)
  Future<void> updateNote(String docID, Map<String, String> updatedNote, {bool? isFavorite}) async {
    try {
      await notes.doc(docID).update({
        'title': updatedNote['title'] ?? 'Untitled',
        'description': updatedNote['description'] ?? '',
        'timestamp': Timestamp.now(),
        'isFavorite': isFavorite ?? false,  // Update the isFavorite field if provided
      });
    } catch (e) {
      print("Error updating note: $e");
      rethrow;
    }
  }

  // Delete (Remove a note)
  Future<void> deleteNote(String docID) async {
    try {
      await notes.doc(docID).delete();
    } catch (e) {
      print("Error deleting note: $e");
      rethrow;
    }
  }
}
