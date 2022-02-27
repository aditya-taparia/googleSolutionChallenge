import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googlesolutionchallenge/screens/auth/login.dart';
import 'package:googlesolutionchallenge/screens/home/home.dart';
import 'package:googlesolutionchallenge/screens/start.dart';
import 'package:googlesolutionchallenge/stepper/steps.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

int? isviewed;

void main() async {
  //used to interact with the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();
  // Call firebase from device
  await Firebase.initializeApp();

  // Shared Preference
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

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
      home: isviewed != 0 ? const Start() : const Login(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (_isLoading) {
      return Container();
    } else {
      if (user == null) {
        return isviewed != 0 ? Start() : Login();
      } else {
        return Home();
      }
    }
  }
}
