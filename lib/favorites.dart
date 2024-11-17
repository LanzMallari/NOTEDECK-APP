import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'note.dart';  // For navigating to NoteScreen
import 'services/firestore.dart';
import 'dart:math';

class FavoritesPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final List<Color> colors = [];

  // Generate a random light color for notes
  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      180 + random.nextInt(76), // R value between 180 and 255
      180 + random.nextInt(76), // G value between 180 and 255
      180 + random.nextInt(76), // B value between 180 and 255
      1.0, // Opaque color
    );
  }

  // Ensure enough colors are available for notes
  void _ensureColors(int count) {
    while (colors.length < count) {
      colors.add(_generateRandomColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorites"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 241, 223, 58), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getFavoriteNotesStream(), // Only fetch favorite notes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          final notes = snapshot.data!.docs;
          _ensureColors(notes.length); // Ensure enough random colors

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two notes per row
                crossAxisSpacing: 8.0, // Horizontal space between items
                mainAxisSpacing: 8.0, // Vertical space between items
                childAspectRatio: 0.8, // Fixed aspect ratio for consistent size
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final String docID = note.id;
                final Map<String, dynamic> data = note.data() as Map<String, dynamic>;
                final String title = data['title'] ?? 'Untitled Note';
                final String description = data['description'] ?? 'No description available';
                final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                final String formattedDate =
                DateFormat('EEE, d MMM yyyy, h:mm a').format(timestamp.toDate());

                // Display a truncated description
                final String briefDescription = description.length > 50
                    ? '${description.substring(0, 50)}...'
                    : description;

                return GestureDetector(
                  onTap: () {
                    // Navigate to NoteScreen to edit the favorite note
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          docID: docID,
                          initialTitle: title,
                          initialText: description,
                          isFavorite: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colors[index], // Random light background color
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Dark text for contrast
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          briefDescription,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87, // Slightly muted color for description
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54, // Muted text color for date
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
