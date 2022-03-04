// @siko otp page// @siko otp page

import 'package:flutter/foundation.dart';
import 'package:googlesolutionchallenge/services/auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Otptest extends StatefulWidget {
  final String verificationIdFinal;
  final String number;
  const Otptest(this.verificationIdFinal, this.number) : super();

  @override
  _OtptestState createState() => _OtptestState(verificationIdFinal, number);
}

class _OtptestState extends State<Otptest> {
  final String verificationIdFinal;
  final String number;
  _OtptestState(this.verificationIdFinal, this.number);

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5.0),
  );

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // var number = "+917287042678";
  final AuthService _auth = AuthService();
  late FocusNode myFocusNode;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    SmsAutoFill().listenForCode.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(0, 89, 67, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        'Enter Verification code',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 89, 67, 1),
                        ),
                      ))),
              const SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'OTP sent to ${number} ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 70,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  // height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //OTP
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(38.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      print(_formKey.currentState?.validate());
                                    },
                                    child: PinPut(
                                      validator: (s) {},
                                      // useNativeKeyboard: false,
                                      autovalidateMode: AutovalidateMode.always,
                                      withCursor: true,
                                      fieldsCount: 6,
                                      fieldsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textStyle: const TextStyle(
                                          fontSize: 25.0, color: Colors.black),
                                      eachFieldMargin: EdgeInsets.all(0),
                                      eachFieldWidth: 45.0,
                                      eachFieldHeight: 55.0,
                                      onSubmit: (String pin) => {},
                                      onChanged: (String pin) {
                                        if (pin.length == 6) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        }
                                      },
                                      focusNode: FocusNode(),
                                      controller: otpController,
                                      submittedFieldDecoration:
                                          pinPutDecoration.copyWith(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.7,
                                          color: Colors.black,
                                        ),
                                      ),

                                      selectedFieldDecoration:
                                          pinPutDecoration.copyWith(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color: Color.fromRGBO(0, 89, 67, 1),
                                        ),
                                      ),
                                      followingFieldDecoration:
                                          pinPutDecoration.copyWith(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.7,
                                          color: Colors.black,
                                        ),
                                      ),
                                      pinAnimationType: PinAnimationType.scale,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(0, 89, 67, 1),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      fixedSize: const Size(330.0, 50.0),
                                    ),
                                    onPressed: () async {
                                      try {
                                        print('otp screen');
                                        print(verificationIdFinal);
                                        await _auth.signInwithPhoneNumber(
                                            verificationIdFinal,
                                            otpController.text,
                                            context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    Wrapper()));
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Verify Code',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      side: BorderSide(
                                        width: 1.0,
                                        color: Color.fromARGB(255, 1, 153, 115),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      fixedSize: const Size(330.0, 50.0),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Resend Code',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 89, 67, 1),
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }
}

Widget otp_field(context, {required bool first, last}) {
  return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
              counter: Offstage(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Color.fromRGBO(0, 89, 67, 1)),
                borderRadius: BorderRadius.circular(12),
              )),
        ),
      ));
}
