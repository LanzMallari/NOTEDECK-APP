import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notedeck_app/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBpiyScoTPLaAAadMUx0IG9rF-PBwbtBu0",
          appId: "1:623410508138:android:5d314991338eb5fa167513",
          messagingSenderId: "623410508138",
          projectId: "notedeck-94a49"));

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
