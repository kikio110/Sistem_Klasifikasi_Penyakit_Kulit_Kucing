import 'package:flutter/material.dart';
import 'pages/home_pages.dart'; // import halaman home

void main() {
  runApp(const CatcareApp());
}

class CatcareApp extends StatelessWidget {
  const CatcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catcare',
      debugShowCheckedModeBanner: false,
      home: const HomePage(), // Panggil HomePage
    );
  }
}
