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
          headline1: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headline2: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headline3: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headline4: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headline5: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          headline6: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          subtitle1: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 16, color: Colors.white),
          subtitle2: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 14, color: Colors.white),
          bodyText1: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 14, color: Colors.white),
          bodyText2: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 12, color: Colors.white),
          button: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 14, color: Colors.white),
          caption: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 12, color: Colors.white),
          overline: TextStyle(
              fontFamily: 'IRANSansX', fontSize: 10, color: Colors.white),
        ),
      ),
      home: CurrencyScreen(),
    );
  }
}
