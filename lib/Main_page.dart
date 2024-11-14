import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notedeck_app/login_page.dart';
import 'package:notedeck_app/notes_create.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Taskbar with Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 241, 223, 58),  // Yellow
                  Colors.white,  // White
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Title aligned to the left
                const Text(
                  'NOTEDECK',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  // Black color for text
                  ),
                ),

                // Spacer to push the buttons to the right
                const Spacer(),

                // Row containing heart and logout button, aligned to the right
                Row(
                  children: [
                    // Action Icon Button (Heart)
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.heart,
                        color: Colors.black,  // Black color for the icon
                      ),
                      onPressed: () {
                        // Action to perform when button is pressed
                      },
                    ),
                    // Logout Icon Button
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.signOutAlt, // Icon for logout
                        color: Colors.black,  // Black color for icon
                      ),
                      onPressed: _logout, // Call _logout when button is pressed
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search Bar with Gradient Background
          Padding(
            padding: const EdgeInsets.all(12.12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search For Notes?',
                prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white, // White background for the text field
              ),
            ),
          ),
          // Main content area
          const Expanded(
            child: Center(
              child: Text('Your notes will appear here.'),
            ),
          ),
        ],
      ),
      // Floating Action Button with Gradient Background
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 241, 223, 58),  // Yellow
              Colors.white,  // White
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,  // To make it circular
        ),
        child: FloatingActionButton(
          onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotePage()),
          );
            // Action to perform when button is pressed (e.g., navigate to another screen)
          },
          backgroundColor: Colors.transparent,  // Transparent for the gradient
          child: const Icon(
            FontAwesomeIcons.plus,  // Add icon
            color: Colors.black,  // Icon color (black)
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,  // Position at the lower right
    );
  }
}
