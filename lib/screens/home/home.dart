import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ElevatedButton(
        onPressed: () => {_auth.signOut()},
        child: Text('taparia chuthiya'),
      ),
    );
  }
}
