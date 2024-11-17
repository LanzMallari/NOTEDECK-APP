import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // For generating random colors
import 'package:intl/intl.dart'; // For formatting dates and times
import 'login_page.dart';
import 'note.dart'; // Import the new NoteScreen
import 'package:notedeck_app/services/firestore.dart';
import 'favorites.dart';  // Import the new FavoritesPage
import 'note.dart'; // Import the NoteScreen

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirestoreService firestoreService = FirestoreService();
  final List<Color> colors = []; // To store random colors for notes
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> filteredNotes = [];
  bool isSearching = false;

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

  // Ensure we have enough colors for the notes
  void _ensureColors(int count) {
    while (colors.length < count) {
      colors.add(_generateRandomColor());
    }
  }

  // Filter notes based on search query
  void _filterNotes(String query, List<DocumentSnapshot> notes) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredNotes = notes.where((note) {
          final title = note['title']?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  // Logout method
  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    FirebaseAuth.instance.signOut();
  }

  // Navigate to the FavoritesPage when the favorite icon is clicked
  void navigateToFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("NOTEDECK"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 241, 223, 58), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            // Favorite Icon Button
            IconButton(
              onPressed: navigateToFavoritesPage,
              icon: const Icon(Icons.favorite),
              tooltip: 'Go to Favorites',
            ),
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navigate to NoteScreen when FAB is clicked
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteScreen()),
            );

            if (result != null && result == 'Note saved') {
              setState(() {}); // Update the UI after saving a note
            }
          },
          backgroundColor: Colors.yellow, // Set the background color to yellow
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    isSearching = query.isNotEmpty;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getNotesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> notesList = snapshot.data!.docs;
                    _ensureColors(notesList.length); // Ensure colors match note count

                    // Filter notes based on search query
                    final displayedNotes = isSearching
                        ? notesList.where((note) {
                      final title = note['title']?.toString().toLowerCase() ?? '';
                      return title.contains(searchController.text.toLowerCase());
                    }).toList()
                        : notesList;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 8.0, // Horizontal space between items
                          mainAxisSpacing: 8.0, // Vertical space between items
                          childAspectRatio: 0.8, // Set fixed aspect ratio for consistent box sizes
                        ),
                        itemCount: displayedNotes.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = displayedNotes[index];
                          String docID = document.id;
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          String noteTitle = data['title'] ?? '';  // Assuming title field
                          String noteDescription = data['description'] ?? '';  // Assuming description field
                          Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                          String formattedDate = DateFormat('EEE, d MMM yyyy, h:mm a').format(timestamp.toDate());

                          // Display only a small part of the description
                          String briefDescription = noteDescription.length > 50
                              ? noteDescription.substring(0, 50) + '...'
                              : noteDescription;

                          return GestureDetector(
                            onTap: () async {
                              // Navigate to NoteScreen to edit the note
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteScreen(docID: docID, initialText: noteDescription, initialTitle: noteTitle),
                                ),
                              );

                              if (result != null && result == 'Note saved') {
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: colors[index], // Use a random light color for the note
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
                                    noteTitle,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Dark color for title to improve contrast
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    briefDescription,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87, // Darker color for description
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54, // Muted color for date and time
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
