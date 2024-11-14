import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<QuerySnapshot> _usersFuture;

  @override
  void initState() {
    super.initState();
    // Fetching users when the page is initialized
    _usersFuture = _fetchUsers();
  }

  // Fetch all users from the Firestore 'users' collection
  Future<QuerySnapshot> _fetchUsers() async {
    try {
      // Query Firestore for all users
      return await _firestore.collection('users').get();
    } catch (e) {
      print("Error fetching users: $e");
      rethrow; // You can handle errors here as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _usersFuture, // The future that fetches users
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            // Extract users from the snapshot
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  title: Text(user['email']),  // Display user email
                  subtitle: Text('UID: ${user['uid']}'),  // Display user UID
                );
              },
            );
          }
        },
      ),
    );
  }
}
