import 'package:flutter/material.dart';
import 'package:notedeck_app/login_page.dart';
import 'package:notedeck_app/otp_page.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

final TextEditingController _usernameController = TextEditingController();

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar container with back button and title in the center
          Container(
            height: 60, // Height of the top bar
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color.fromARGB(
                255, 241, 223, 58), // Background color of the top bar
            child: Row(
              children: [
                // Back button on the left
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      'Forgot Password',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white, // Text color
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

          // Username input field
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              keyboardType: TextInputType.text,
            ),
          ),

          // NEXT button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to OTP page when NEXT button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpPage()),
                );
              },
              child: const Text('NEXT'),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                backgroundColor:
                    const Color.fromARGB(255, 241, 223, 58), // Button color
                foregroundColor: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
