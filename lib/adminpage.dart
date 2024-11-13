import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to hold the users from Firestore
  List<QueryDocumentSnapshot> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsersFromFirestore();
  }

  // Fetch users from Firestore
  Future<void> _fetchUsersFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      setState(() {
        _users = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users from Firestore: $e')),
      );
    }
  }

  // Delete the user from Firestore
  Future<void> _deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();

      setState(() {
        // Remove user from the list
        _users.removeWhere((user) => user.id == uid);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User $uid deleted successfully from Firestore.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user from Firestore: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page - User Accounts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index].data() as Map<String, dynamic>;
          final userId = _users[index].id;
          final userEmail = user['email'] ?? 'No Email';

          return ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.blue),
            title: Text(userEmail),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(userId),
            ),
          );
        },
      ),
    );
  }
}
