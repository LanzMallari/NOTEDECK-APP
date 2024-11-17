import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notedeck_app/note.dart';
import 'package:notedeck_app/notes_create.dart';
import 'package:notedeck_app/services/firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorites"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 241, 223, 58), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),




            );




  }
}
