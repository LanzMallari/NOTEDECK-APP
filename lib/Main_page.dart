import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notedeck_app/login_page.dart';

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
          // Taskbar
          Container(
            color: const Color.fromARGB(255, 185, 182, 182), // Gray color for the taskbar
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Action Icon Button
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Action to perform when button is pressed
                  },
                ),
                // Title centered in the row
                const Text(
                  'NOTEDECK',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Logout Icon Button
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.signOutAlt, // Icon for logout
                    color: Colors.white,
                  ),
                  onPressed: _logout, // Call _logout when button is pressed
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search For Notes?',
                prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 185, 182, 182),
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
    );
  }
}
