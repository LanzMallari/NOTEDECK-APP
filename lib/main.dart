import 'package:flutter/material.dart';
import 'package:notedeck_app/create_page.dart';
import 'package:notedeck_app/forgot_page.dart';
import 'package:notedeck_app/login_page.dart';
import 'Main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Deck',
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
