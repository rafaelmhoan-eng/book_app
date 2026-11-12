import 'package:flutter/material.dart';
import 'screens/books_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Իմ գրքերը',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 204, 195, 221),
        scaffoldBackgroundColor: const Color.fromARGB(255, 113, 144, 225),
      ),
      home: const BooksScreen(),
    );
  }
}
