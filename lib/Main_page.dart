import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Import StaggeredGridView
import 'dart:math';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'note.dart';
import 'package:notedeck_app/services/firestore.dart';
import 'favorites.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirestoreService firestoreService = FirestoreService();
  final List<Color> colors = []; // Store random colors for notes
  final Random random = Random(); // Random generator
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> filteredNotes = [];
  bool isSearching = false;

  // Generate a random light color for notes
  Color _generateRandomColor() {
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
          automaticallyImplyLeading: false, // Disable the back button
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
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteScreen()),
            );

            if (result != null && result == 'Note saved') {
              setState(() {}); // Update the UI after saving a note
            }
          },
          backgroundColor: Colors.yellow,
          child: const Icon(Icons.add),
          shape: const CircleBorder(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
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
                    _ensureColors(notesList.length);

                    final displayedNotes = isSearching
                        ? notesList.where((note) {
                      final title =
                          note['title']?.toString().toLowerCase() ?? '';
                      return title
                          .contains(searchController.text.toLowerCase());
                    }).toList()
                        : notesList;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MasonryGridView.builder(
                        gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                        ),
                        mainAxisSpacing: 8.0, // Vertical space between items
                        crossAxisSpacing: 8.0, // Horizontal space between items
                        itemCount: displayedNotes.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = displayedNotes[index];
                          String docID = document.id;
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          String noteTitle = data['title'] ?? '';
                          String noteDescription = data['description'] ?? '';
                          Timestamp timestamp =
                              data['timestamp'] ?? Timestamp.now();
                          String formattedDate = DateFormat(
                              'EEE, d MMM yyyy, h:mm a')
                              .format(timestamp.toDate());

                          // Generate random height for each note
                          double randomHeight =
                              random.nextDouble() * 100 + 150; // 150 to 250

                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteScreen(
                                    docID: docID,
                                    initialText: noteDescription,
                                    initialTitle: noteTitle,
                                  ),
                                ),
                              );

                              if (result != null && result == 'Note saved') {
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: randomHeight,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: colors[index],
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
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    noteDescription.length > 50
                                        ? noteDescription.substring(0, 50) +
                                        '...'
                                        : noteDescription,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
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
