import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/widgets/phone_number.dart';
import 'package:particles_flutter/particles_flutter.dart';

import '../../services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Color color;
  Color themecolor = const Color.fromRGBO(66, 103, 178, 1);
  late double borderRadius;
  late double height;
  late double margin;
  int count = 0;
  int? stepsUsed;

  final Duration _duration = const Duration(seconds: 1);
  final AuthService _auth = AuthService();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  double rRadius() {
    return 30;
  }

  Color rColor() {
    return themecolor;
  }

  @override
  void initState() {
    super.initState();
    change();
  }

  void change() async {
    if (count < 3) {
      setState(() {
        color = rColor();
        borderRadius = rRadius();
        if (count < 1) {
          height = 0;
        } else {
          height = 450;
        }
        count++;
      });
    } else {
      return null;
    }

    await Future.delayed(const Duration(seconds: 1), change);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themecolor,
      body: Stack(
        children: [
          Container(
            key: UniqueKey(),
            child: Center(
              child: CircularParticle(
                awayRadius: 20,
                numberOfParticles: 150,
                speedOfParticles: 1.5,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                onTapAnimation: true,
                particleColor: Colors.white12,
                awayAnimationDuration: const Duration(milliseconds: 100),
                maxParticleSize: 3,
                isRandSize: true,
                isRandomColor: false,
                awayAnimationCurve: Curves.easeInOut,
                enableHover: true,
                hoverColor: Colors.white12,
                hoverRadius: 90,
                connectDots: true,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 150,
                  child: ClipRRect(
                    child: Image(
                      image: AssetImage('assets/splashScreenDark.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Earn . Lend . Donate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius)),
                ),
                duration: _duration,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Let's Link",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: themecolor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone number",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            PhoneNumber(
                              phoneController: phoneController,
                              codeController: codeController,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: themecolor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                fixedSize: const Size(500.0, 50.0),
                              ),
                              onPressed: () async {
                                try {
                                  String phone = codeController.text == ''
                                      ? codeController.text +
                                          phoneController.text
                                      : '+91' + phoneController.text;
                                  await _auth.verifyPhoneNumber(phone, context);
                                } catch (e) {
                                  rethrow;
                                }
                              },
                              child: const Text(
                                'Send Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Sign in with Google'),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            try {
                              await _auth.signInWithGoogle();
                            } catch (e) {
                              rethrow;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google-icon.png',
                                fit: BoxFit.scaleDown,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.grey[800],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(500.0, 50.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
