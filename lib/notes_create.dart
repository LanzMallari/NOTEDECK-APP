import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // Ensure collection name 'notedeck' is correctly referenced
  final CollectionReference myNoteDeck = FirebaseFirestore.instance.collection('notedeck');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: const Text('Notes'),
        actions: [
          _buildFavoriteButton(),
          _buildSaveButton(),
        ],
        backgroundColor: const Color.fromARGB(255, 241, 223, 58),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleTextField(),
            const SizedBox(height: 20),
            _buildNoteTextField(),
          ],
        ),
      ),
    );
  }

  // Helper method to build the back button in the AppBar
  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // Helper method to build the favorite button in the AppBar
  Widget _buildFavoriteButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.black : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _isFavorite = !_isFavorite;
          });
        },
      ),
    );
  }

  // Helper method to build the save button in the AppBar
  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.save, color: Colors.black),
        onPressed: saveNote,
      ),
    );
  }

  // Helper method to build the title TextField
  Widget _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        border: UnderlineInputBorder(),
      ),
      style: const TextStyle(fontSize: 22),
    );
  }

  // Helper method to build the note TextField
  Widget _buildNoteTextField() {
    return Expanded(
      child: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          hintText: 'Type your notes here...',
          border: InputBorder.none,
        ),
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  // Method to save the note to Firestore
  Future<void> saveNote() async {
    try {
      final title = _titleController.text.trim();
      final note = _noteController.text.trim();

      // Ensure title and note are not empty
      if (title.isEmpty || note.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both title and note content.')),
        );
        return;
      }

      // Prepare the note data
      final noteData = {
        'title': title,
        'note': note,
        'isFavorite': _isFavorite,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the note to Firestore in 'notedeck' collection
      await myNoteDeck.add(noteData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved successfully!')),
      );

      // Clear the input fields and reset favorite state
      _titleController.clear();
      _noteController.clear();
      setState(() {
        _isFavorite = false;
      });
    } catch (e) {
      // Handle errors during note saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
