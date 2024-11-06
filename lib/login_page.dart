import 'package:flutter/material.dart';
import 'package:notedeck_app/Main_page.dart';
import 'package:notedeck_app/create_page.dart';
import 'package:notedeck_app/forgot_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // White background for the page
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container for the image at the top
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'images/list1.png', // Replace with your image path
                    width: 100,
                    height: 100,
                  ),
                ),

                // Title below the image
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'NoteDeck',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 241, 223, 58), // Yellow color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Container for the username field
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),

                // Container for the password field
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),

                // Forgot password button aligned to the right
                Container(
                  alignment:
                      Alignment.centerRight, // Align the container to the right
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPage()),
                      );

                      // Add forgot password logic here
                      print('Forgot Password Pressed');
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 241, 223, 58), // Button color
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                // Container for the login button
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add login logic here
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      print('Username: $username, Password: $password');
                    },
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(double.infinity, 50), // Full width button
                      backgroundColor: const Color.fromARGB(
                          255, 241, 223, 58), // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                  ),
                ),

                // Container for the Create Account button
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAcc()),
                      );
                      // Navigate to account creation page or perform action
                      print('Create Account Pressed');
                    },
                    child: const Text(
                      'Create Account?',
                      style: TextStyle(
                        color: Colors.black, // Black text color
                        fontSize: 13, // Font size 13
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
