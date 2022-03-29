import 'package:flutter/foundation.dart';
import 'package:googlesolutionchallenge/main.dart';
import 'package:googlesolutionchallenge/services/auth.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';

class Otp extends StatefulWidget {
  final String verificationIdFinal;
  final String number;
  const Otp({Key? key, required this.verificationIdFinal, required this.number}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  _OtpState();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5.0),
  );

  final _isLoading = false;
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color.fromRGBO(66, 103, 178, 1),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Loading()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Enter Verification code',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(66, 103, 178, 1),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'OTP sent to ${widget.number} ',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //OTP
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: PinPut(
                              validator: (s) {
                                return null;
                              },
                              // useNativeKeyboard: false,
                              autovalidateMode: AutovalidateMode.always,
                              withCursor: true,
                              fieldsCount: 6,
                              fieldsAlignment: MainAxisAlignment.spaceAround,
                              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                              eachFieldMargin: const EdgeInsets.all(0),
                              eachFieldWidth: 45.0,
                              eachFieldHeight: 55.0,
                              onSubmit: (String pin) => {},
                              onChanged: (String pin) {
                                if (pin.length == 6) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }
                              },
                              focusNode: FocusNode(),
                              controller: otpController,
                              submittedFieldDecoration: pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 0.7,
                                  color: Colors.black,
                                ),
                              ),

                              selectedFieldDecoration: pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(66, 103, 178, 1),
                                ),
                              ),
                              followingFieldDecoration: pinPutDecoration.copyWith(
                                color: Colors.white,
                                border: Border.all(
                                  width: 0.7,
                                  color: Colors.black,
                                ),
                              ),
                              pinAnimationType: PinAnimationType.scale,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(66, 103, 178, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await _auth.signInwithPhoneNumber(widget.verificationIdFinal, otpController.text, context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => const Wrapper(),
                                    ),
                                  );
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: const Color.fromRGBO(66, 103, 178, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
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

Widget otpField(context, {required bool first, last}) {
  return SizedBox(
    height: 85,
    child: AspectRatio(
      aspectRatio: 0.8,
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Color.fromRGBO(66, 103, 178, 1)),
              borderRadius: BorderRadius.circular(12),
            )),
      ),
    ),
  );
}
