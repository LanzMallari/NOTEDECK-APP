import 'package:flutter/material.dart';
import 'services/firestore.dart'; // Import FirestoreService

class NoteScreen extends StatefulWidget {
  final String? docID; // Optional document ID for editing an existing note
  final String? initialText; // Optional initial text for editing
  final String? initialTitle; // Optional initial title for editing
  final bool? isFavorite; // Optional initial favorite status

  const NoteScreen({super.key, this.docID, this.initialText, this.initialTitle, this.isFavorite});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // If editing an existing note, pre-fill the fields and favorite status
    if (widget.docID != null) {
      titleController.text = widget.initialTitle ?? '';
      descriptionController.text = widget.initialText ?? '';
      isFavorite = widget.isFavorite ?? false; // Set the favorite status
    }
  }

  // Toggle favorite status
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (widget.docID != null) {
      // Update favorite status in Firestore for existing note
      firestoreService.updateNote(
        widget.docID!,
        {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
        },
        isFavorite: isFavorite,
      );
    }
  }

  // Save note (add or update)
  void saveNote() async {
    if (widget.docID == null) {
      // Add a new note
      await firestoreService.addNote(
        {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
        },
        isFavorite: isFavorite,
      );
    } else {
      // Update an existing note
      await firestoreService.updateNote(
        widget.docID!,
        {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
        },
        isFavorite: isFavorite,
      );
    }

    // Close the screen and return to MainPage
    Navigator.pop(context, 'Note saved');
  }

  // Delete note
  void deleteNote() {
    if (widget.docID != null) {
      // Delete the note if editing an existing one
      firestoreService.deleteNote(widget.docID!);

      // Close the screen and return to MainPage
      Navigator.pop(context, 'Note deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docID == null ? 'Add Note' : 'Edit Note'),
          backgroundColor: Colors.grey[300],
        leading: IconButton(  // Add the back button here
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),  // This will take you back to the previous screen
          tooltip: 'Back',
        ),
        actions: [
          // Favorite button
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null, // Change the color when favorite
            ),
            tooltip: 'Mark as Favorite',
            onPressed: toggleFavorite,
          ),
          if (widget.docID != null)
          // Delete button
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Note',
              onPressed: deleteNote,
            ),
          // Save button
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.save),
            tooltip: 'Save Note',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            TextField(
              controller: titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'TITLE...',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none, // Removes visible lines
              ),
            ),
            const SizedBox(height: 16.0),

            // Description Field
            Expanded(
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5, // Adjust line height
                ),
                decoration: const InputDecoration(
                  hintText: 'Start typing your notes here...',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                  border: InputBorder.none, // Removes visible lines
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
