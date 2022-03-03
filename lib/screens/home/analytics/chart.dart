import 'package:flutter/material.dart';

class chart extends StatefulWidget {
  const chart({Key? key}) : super(key: key);

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Work in Progress"),
      ),
    );
  }
}
