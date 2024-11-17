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
      isFavorite = widget.isFavorite ?? false;
    }
  }

  // Toggle the favorite status
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (widget.docID != null) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add or update note in Firestore
                if (widget.docID == null) {
                  firestoreService.addNote(
                    {
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                    },
                    isFavorite: isFavorite,
                  );
                } else {
                  firestoreService.updateNote(
                    widget.docID!,
                    {
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                    },
                    isFavorite: isFavorite,
                  );
                }
                Navigator.pop(context); // Go back to the previous page
              },
              child: Text(widget.docID == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
