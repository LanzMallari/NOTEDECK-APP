import 'package:flutter/material.dart';

class NewpassPage extends StatefulWidget {
  const NewpassPage({super.key});

  @override
  State<NewpassPage> createState() => _NewpassPageState();
}

class _NewpassPageState extends State<NewpassPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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
                  'Create New Password',
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
                    labelText: 'New Password',
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
                    minimumSize: Size(double.infinity, 50), // Full width button
                    backgroundColor:
                        const Color.fromARGB(255, 241, 223, 58), // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                ),
              ),

              // Container for the Create Account button
            ],
          ),
        ),
      ),
    ),
  );
}
