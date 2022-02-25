import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/login/login.dart';
import 'package:googlesolutionchallenge/screens/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Login(), // Change it back to Start()
    );
  }
}
