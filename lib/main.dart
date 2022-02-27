import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googlesolutionchallenge/screens/auth/login.dart';
import 'package:googlesolutionchallenge/screens/start.dart';
import 'package:googlesolutionchallenge/stepper/steps.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
void main() async {
  //used to interact with the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();
  // Call firebase from device
  await Firebase.initializeApp();

  // Shared Preference
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');
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
      home: isViewed != 0 ? const Start() : const Login(),
    );
  }
}
