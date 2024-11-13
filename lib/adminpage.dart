import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _fetchUsers() {
    return _firestore.collection('users').snapshots();
  }

  Future<void> _deleteUser(String uid) async {
    try {
      // Delete the user from Firestore
      await _firestore.collection('users').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User $uid deleted from Firestore.')),
      );

      // If you are in an Admin environment or using Firebase Admin SDK,
      // here you can make the call to delete the user from Firebase Auth as well.
      // Note: You will need Firebase Admin SDK or a privileged user for this.
      // For client-side Firebase Authentication, only the logged-in user can delete their own account.

      // If you had access to Firebase Admin SDK (in backend/server-side):
      // FirebaseAdmin SDK code to delete user goes here.
      // Example (Not for client-side use):
      // admin.auth().deleteUser(uid);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page - User Accounts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final user = doc.data() as Map<String, dynamic>;
              final userId = doc.id;
              final userEmail = user['email'] ?? 'No Email';
              return ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: Text(userEmail),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(userId),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
