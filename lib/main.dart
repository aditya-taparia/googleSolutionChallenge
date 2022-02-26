import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googlesolutionchallenge/screens/auth/login.dart';
import 'package:googlesolutionchallenge/screens/start.dart';
import 'package:googlesolutionchallenge/widgets/phone_number.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Theme data of the app
    ThemeData _theme = ThemeData(
      fontFamily: GoogleFonts.varelaRound().fontFamily,
      backgroundColor: Colors.blueGrey[50],
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.varelaRound().fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: _theme,
      home: const Login(),
    );
  }
}
