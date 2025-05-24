import 'dart:async';
import 'package:flutter/material.dart';
import 'home_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer 2 detik, lalu navigasi ke HomePage
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            onToggleLanguage: _toggleLanguage,
            currentLocale: _locale,
          ),
        ),
      );
    });
  }

  // Fungsi untuk nyambungin dengan data dari main
  Locale _locale = const Locale('en');
  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? const Locale('id') : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              'CatCare Mobile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
