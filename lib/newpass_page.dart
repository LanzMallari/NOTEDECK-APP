import 'package:flutter/material.dart';
import 'package:notedeck_app/login_page.dart';
import 'package:notedeck_app/otp_page.dart'; // You can change this to the actual next page.

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPasswordController = TextEditingController();

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar container with back button and title in the center
          Container(
            height: 60, // Height of the top bar
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Colors.white], // Yellow to White gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Back button on the left
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
                // Expanded widget to center the title in the middle
                Expanded(
                  child: Center(
                    child: Text(
                      'Create New Password',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black, // Text color changed to black for contrast
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Space for the rest of the content on the page
          SizedBox(
            height: 250,
          ),

          // Password input field
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true, // Hide the password text
              keyboardType: TextInputType.text,
            ),
          ),

          // Confirm Password input field
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true, // Hide the confirm password text
              keyboardType: TextInputType.text,
            ),
          ),

          // CONFIRM button with gradient background
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Colors.white], // Yellow to White gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8), // Optional: rounded corners for the button
            ),
            child: ElevatedButton(
              onPressed: () {
                // Validate the passwords match
                if (_passwordController.text == _confirmPasswordController.text) {
                  // Navigate to the next page after confirming password match
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpPage()), // Or any other page
                  );
                } else {
                  // Show error message if passwords don't match
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match!"),
                    ),
                  );
                }
              },
              child: const Text('CONFIRM'),
              style: ElevatedButton.styleFrom(
                minimumSize:
                const Size(double.infinity, 50), // Full width button
                backgroundColor: Colors.transparent, // Set to transparent to show the gradient
                foregroundColor: Colors.black, // Text color
                shadowColor: Colors.transparent, // No shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Match the border radius of the container
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
