import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/auth/UI/login.dart';
import 'package:reddit_clone/Theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Pallete.darkModeAppTheme,
      home: const SafeArea(child: LoginScreen()),
    );
  }
}
