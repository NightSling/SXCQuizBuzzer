import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SXC Quiz',
      theme: ThemeData(
        colorScheme: const ColorScheme.highContrastDark(
          primary: Colors.blue,
          secondary: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'SXC Quiz'),
    );
  }
}
