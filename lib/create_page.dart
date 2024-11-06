import 'package:flutter/material.dart';

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the page
      body: Stack(
        children: [
          // SingleChildScrollView for the rest of the content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container for the "Create Account" title
                  SizedBox(
                    height: 230,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 25, // Font size 20 for the title
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Container for the description text

                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: const Text(
                      'Enter your email and password to\n create an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14, // Font size 14 for the description
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Container for the "Email" label and email field
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  // Password input section
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                  ),
                  // Password requirements text
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      '● Must be at least 8 characters',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Submit Button
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add create account logic here
                        String username = _usernameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        print(
                            'Username: $username, Email: $email, Password: $password');
                      },
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(double.infinity, 50), // Full width button
                        backgroundColor: const Color.fromARGB(
                            255, 241, 223, 58), // Button color
                        foregroundColor: Colors.white, // Text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button inside a Container and aligned to the left
          Positioned(
            top: 40, // Adjust this value as needed
            left: 0, // Aligns the container to the left
            child: Container(
              padding: const EdgeInsets.all(8), // Add padding to the container
              alignment:
                  Alignment.centerLeft, // Align the button inside the container
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
