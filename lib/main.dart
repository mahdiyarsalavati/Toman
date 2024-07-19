import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CurrencyScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF1C1C1E),
        primaryColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headlineMedium: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          bodyLarge: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          bodyMedium: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          bodySmall: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          labelLarge: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 14, color: Colors.white),
          labelSmall: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 12, color: Colors.white),
        ),
      ),
      home: CurrencyScreen(),
    );
  }
}
