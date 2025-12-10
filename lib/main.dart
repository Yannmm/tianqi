import 'package:flutter/material.dart';
import 'package:tianqi/view/home.dart';
import 'package:tianqi/view/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tianqi Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const Home(),
      home: WelcomePageNaturalFade(),
    );
  }
}
