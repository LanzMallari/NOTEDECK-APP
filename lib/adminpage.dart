import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      // Fetch all users from the Firestore 'users' collection
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        return {
          'email': doc['email'] ?? 'No Email',
          'uid': doc['uid'] ?? 'No UID',
          'docId': doc.id, // Store the document ID for deletion
        };
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      rethrow;
    }
  }

  // Delete a user from both Firestore and Firebase Authentication
  Future<void> _deleteUser(String docId, String userUid) async {
    try {
      // Delete the user from Firestore
      await _firestore.collection('users').doc(docId).delete();

      // Get the current authenticated user
      User? user = _auth.currentUser;

      if (user != null && user.uid == userUid) {
        // If the user is the same as the one being deleted, delete the Firebase Authentication account
        await user.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted from Firebase Authentication and Firestore')),
        );
      } else {
        // If it's not the logged-in user, just delete from Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted from Firestore')),
        );
      }

      setState(() {}); // Refresh the list after deletion
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting user')),
      );
    }
  }

  // Logout the user
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
    } catch (e) {
      print("Error logging out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Handle logout when pressed
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            // List of users
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user['email']!),
                  subtitle: Text('UID: ${user['uid']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user['docId'], user['uid']),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
