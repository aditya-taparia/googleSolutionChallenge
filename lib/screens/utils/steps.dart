import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/main.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/services/userdatabase.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyStepper extends StatefulWidget {
  const MyStepper({Key? key}) : super(key: key);

  @override
  _MyStepperState createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  continueStep() {
    if (current <= 2) {
      setState(() => current++);
    }
  }

  previousStep() {
    if (current > 1) {
      setState(() => current--);
    }
  }

  int current = 1;
  List<String> arr = ['Create Username', 'Location Access', 'Create Avatar'];
  String s = 'Finish';
  bool isusername = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Container(
              color: const Color.fromARGB(255, 230, 228, 228),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 50, 0, 40),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: CircularPercentIndicator(
                        animateFromLastPercent: true,
                        radius: 50,
                        progressColor: const Color.fromRGBO(66, 103, 178, 1),
                        percent: current / 3,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "$current/3",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        animation: true,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          arr[current - 1],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Next Step : ${current < 3 ? arr[current] : s}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            switchcase(current, continueStep, previousStep, context,
                nameController, emailController, user!.userid)
          ]),
        ),
      ),
    );
  }
}

Widget switchcase(
    value,
    continueStep,
    previousStep,
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    String userid) {
  switch (value) {
    case 1:
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 38, 10, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Welcome to LINK ',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(66, 103, 178, 1),
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              const Text("Get Linked to us by creating an username",
                  style: TextStyle(fontSize: 15)),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: textfielduse('UserName', false, nameController),
              ),
              textfielduse('Email', false, emailController),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(66, 103, 178, 1),
                          onPrimary: Colors.white,
                          // shadowColor: Colors.red,
                          elevation: 5,
                        ),
                        onPressed: () {
                          // TODO: Call db to add the user
                          UserDatabaseService(uid: userid).setUserData(
                              nameController.text, emailController.text);
                          continueStep();
                        },
                        child: const Text(
                          "Create & Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
      );
    case 2:
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Text('Allow these for the best app experience',
                style: TextStyle(fontSize: 18)),
          ),
          Column(
            children: [
              Column(children: [
                Row(
                  children: [
                    SizedBox(
                        height: 100,
                        width: 120,
                        child: Lottie.asset('assets/location.json')),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'let the needy know your location',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 100,
                          width: 120,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 70,
                            // color: Color.fromRGBO(66, 103, 178, 1),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                  // textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'To show others what you click',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      SizedBox(
                          height: 90,
                          width: 120,
                          child: Lottie.asset('assets/storage.json')),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Text(
                              'Storage',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'To access your files with permission',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(66, 103, 178, 1),
                        onPrimary: Colors.white,
                        // shadowColor: Colors.red,
                        elevation: 5,
                      ),
                      onPressed: () {
                        previousStep();
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(66, 103, 178, 1),
                        onPrimary: Colors.white,
                        // shadowColor: Colors.red,
                        elevation: 5,
                      ),
                      onPressed: () {
                        continueStep();
                      },
                      child: const Text(
                        "Grant access and continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

    case 3:
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 38, 8, 50),
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 100,
                  ),
                  radius: 70,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1),
                      onPrimary: Colors.white,
                      // shadowColor: Colors.red,
                      elevation: 5,
                    ),
                    onPressed: () {
                      previousStep();
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1),
                      onPrimary: Colors.white,
                      // shadowColor: Colors.red,
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (kDebugMode) {
                        print("Shared pref called");
                      }
                      int isstep = 0;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt('onStep', isstep);
                      if (kDebugMode) {
                        print(prefs.getInt('onStep'));
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Wrapper(),
                        ),
                      );
                    },
                    child: const Text(
                      "Skip & Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    default:
      return Container();
  }
}

Widget textfielduse(hint, isdescription, TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      controller: controller,
      maxLines: isdescription ? 5 : 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        // labelText: "Enter Email",
        hintText: hint,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: const BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        return null;
      },
      keyboardType: TextInputType.text,
    ),
  );
}
