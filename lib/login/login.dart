import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:particles_flutter/particles_flutter.dart';

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

  final Duration _duration = const Duration(seconds: 1);

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
          height = 400;
        }
        count++;
      });
    } else {
      return null;
    }

    await Future.delayed(const Duration(seconds: 3), change);
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
                speedOfParticles: 2,
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
            child: const Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 350,
                child: ClipRRect(
                  child: Image(
                    image: AssetImage('assets/splashScreenDark.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
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
                            IntlPhoneField(
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: themecolor,
                              ),
                              pickerDialogStyle: PickerDialogStyle(),
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                focusColor: themecolor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themecolor,
                                    width: 1.2,
                                  ),
                                ),
                                enabled: true,
                              ),
                              cursorColor: themecolor,
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                if (kDebugMode) {
                                  print(phone.completeNumber);
                                }
                              },
                              validator: (validate) {
                                if (validate!.isEmpty) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
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
                              onPressed: () {},
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
                          onPressed: () {},
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
