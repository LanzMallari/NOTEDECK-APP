import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Taskbar
          Container(
            color: const Color.fromARGB(
                255, 185, 182, 182), // Gray color for the taskbar
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Action Icon Button
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.heart, // Example action icon (settings)
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Action to perform when button is pressed
                    // For example, navigate to a settings page
                  },
                ),
                // Title centered in the row
                Expanded(
                  child: Center(
                    child: Text(
                      'NOTEDECK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
                // You can add more items here in the row if needed
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search For Notes?',
                prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 185, 182, 182),
              ),
            ),
          ),
          // Main content area (optional)
          Expanded(
            child: Center(
              child: Text('Your notes will appear here.'),
            ),
          ),
        ],
      ),
    );
  }
}
