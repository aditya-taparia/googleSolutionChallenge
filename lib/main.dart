import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googlesolutionchallenge/screens/auth/login.dart';
import 'package:googlesolutionchallenge/screens/home/home.dart';
import 'package:googlesolutionchallenge/screens/start.dart';
import 'package:googlesolutionchallenge/services/auth.dart';
import 'package:googlesolutionchallenge/screens/steps.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

int? isviewed;
int? isstep;

void main() async {
  //used to interact with the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();
  // Call firebase from device
  await Firebase.initializeApp();

  // Shared Preference
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  isstep = prefs.getInt('onStep');

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

    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: _theme,
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
      ),
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
    getData();
    _isLoading = false;
  }

  getData() async {
    // Shared Preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isviewed = prefs.getInt('onBoard');
      isstep = prefs.getInt('onStep');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (_isLoading) {
      return const Loading();
    } else {
      if (user == null) {
        return isviewed != 0 ? const Start() : const Login();
      } else {
        return MyStepper(user: user);
        //return isstep != 0 ? const MyStepper() : const Home();
      }
    }
  }
}
