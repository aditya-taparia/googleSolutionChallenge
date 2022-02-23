import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Color color;
  late double borderRadius;
  late double height;

  late double margin;
  int count = 0;

  final Duration _duration = const Duration(seconds: 1);

  double rRadius() {
    return 30;
  }

  Color rColor() {
    return Colors.blue;
  }

  @override
  void initState() {
    super.initState();
    change();
  }

  void change() async {
    if (count < 5) {
      setState(() {
        color = rColor();
        borderRadius = rRadius();
        if (count < 1) {
          height = 0;
        } else {
          height = 450;
        }

        count++;
        print(count);
      });
    } else {
      print('all done');
      return null;
    }

    await Future.delayed(const Duration(seconds: 3), change);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Section 1")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius)),
                ),
                duration: _duration,
                child: Column(
                  children: [Text("LOGIN")],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
