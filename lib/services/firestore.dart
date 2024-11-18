import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the collection reference for the current user's notes
  CollectionReference get _notesCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not authenticated");
    }
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('notedeck');
  }

  // Add a new note
  Future<void> addNote(Map<String, String> note, {bool isFavorite = false}) async {
    try {
      await _notesCollection.add({
        'title': note['title'] ?? 'Untitled',  // Default title if not provided
        'description': note['description'] ?? '',  // Default empty string if no description
        'timestamp': Timestamp.now(),  // Adds the current timestamp
        'isFavorite': isFavorite,  // Passes the favorite flag
      });
    } catch (e) {
      print("Error adding note: $e");
      rethrow;  // Propagate the error
    }
  }

  // Stream all notes for the current user, ordered by timestamp
  Stream<QuerySnapshot> getNotesStream() {
    try {
      return _notesCollection.orderBy('timestamp', descending: true).snapshots();
    } catch (e) {
      print("Error getting notes stream: $e");
      rethrow;  // Propagate the error
    }
  }

  // Stream only favorite notes for the current user
  Stream<QuerySnapshot> getFavoriteNotesStream() {
    try {
      return _notesCollection
          .where('isFavorite', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print("Error getting favorite notes stream: $e");
      rethrow;  // Propagate the error
    }
  }

  // Update an existing note, optionally updating the favorite status
  Future<void> updateNote(String docID, Map<String, String> updatedNote, {bool? isFavorite}) async {
    try {
      // Only update 'title', 'description', and 'isFavorite' fields, not 'timestamp'
      await _notesCollection.doc(docID).update({
        'title': updatedNote['title'] ?? 'Untitled',  // Default title if not provided
        'description': updatedNote['description'] ?? '',  // Default empty string if no description
        'isFavorite': isFavorite ?? false,  // Default to 'false' if 'isFavorite' is null
      });
    } catch (e) {
      print("Error updating note: $e");
      rethrow;  // Propagate the error
    }
  }

  // Delete a note by its document ID
  Future<void> deleteNote(String docID) async {
    try {
      await _notesCollection.doc(docID).delete();
    } catch (e) {
      print("Error deleting note: $e");
      rethrow;  // Propagate the error
    }
  }

  // Check if the user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}
