import 'package:flutter/material.dart';
import 'services/firestore.dart'; // Import FirestoreService

class NoteScreen extends StatefulWidget {
  final String? docID; // Optional document ID for editing an existing note
  final String? initialText; // Optional initial text for editing
  final String? initialTitle; // Optional initial title for editing

  const NoteScreen({super.key, this.docID, this.initialText, this.initialTitle});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // If editing an existing note, pre-fill the fields with provided data
    if (widget.docID != null) {
      titleController.text = widget.initialTitle ?? '';
      descriptionController.text = widget.initialText ?? '';
    }
  }

  // Save note (add or update)
  void saveNote() {
    if (widget.docID == null) {
      // Add a new note
      firestoreService.addNote({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
      });
    } else {
      // Update an existing note
      firestoreService.updateNote(widget.docID!, {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
      });
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
        backgroundColor: Colors.grey,
        actions: [
          // Save button
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.save),
            tooltip: 'Save Note',
          ),

          // Delete button (only visible if editing an existing note)
          if (widget.docID != null)
            IconButton(
              onPressed: deleteNote,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Note',
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
