import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lottie/lottie.dart';

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
  @override
  Widget build(BuildContext context) {
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
                        progressColor: Color.fromRGBO(66, 103, 178, 1),
                        percent: current / 3,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "${current}/3",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        animation: true,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          arr[current - 1],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Next Step : ${current < 3 ? arr[current] : s}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            switchcase(current, continueStep, previousStep)
          ]),
        ),
      ),
    );
  }
}

Widget switchcase(value, continueStep, previousStep) {
  switch (value) {
    case 1:
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 38, 10, 0),
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Welcome to LINK ',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(66, 103, 178, 1),
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 20),
                Text("Get Linked to us by creating an username",
                    style: TextStyle(fontSize: 15)),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Textfielduse('UserName', false),
                ),
                Textfielduse('Describe yourself here', true),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(66, 103, 178, 1),
                            onPrimary: Colors.white,
                            // shadowColor: Colors.red,
                            elevation: 5,
                          ),
                          onPressed: () {
                            continueStep();
                          },
                          child: Text(
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
        ),
      );
    case 2:
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Text('We need these permissions for best app experience',
                style: TextStyle(fontSize: 18)),
          ),
          Column(
            children: [
              Container(
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                          height: 100,
                          width: 120,
                          child: Lottie.asset('assets/location.json')),
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Text(
                              'Location',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'let the need know your location',
                            style: TextStyle(
                              fontSize: 17,
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
                        Container(
                            height: 100,
                            width: 120,
                            child: Lottie.asset('assets/camera.json')),
                        Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Text(
                                'Media',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'To show others what you clicked',
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
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Container(
                            height: 100,
                            width: 120,
                            child: Lottie.asset('assets/storage.json')),
                        Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Text(
                                'Storage',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(66, 103, 178, 1),
                        onPrimary: Colors.white,
                        // shadowColor: Colors.red,
                        elevation: 5,
                      ),
                      onPressed: () {
                        previousStep();
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(66, 103, 178, 1),
                        onPrimary: Colors.white,
                        // shadowColor: Colors.red,
                        elevation: 5,
                      ),
                      onPressed: () {
                        continueStep();
                      },
                      child: Text(
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
      return Container(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 38, 8, 50),
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
                      primary: Color.fromRGBO(66, 103, 178, 1),
                      onPrimary: Colors.white,
                      // shadowColor: Colors.red,
                      elevation: 5,
                    ),
                    onPressed: () {
                      previousStep();
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(66, 103, 178, 1),
                      onPrimary: Colors.white,
                      // shadowColor: Colors.red,
                      elevation: 5,
                    ),
                    onPressed: () {},
                    child: Text(
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
      ));
    default:
      return Container();
  }
}

Widget Textfielduse(hint, isdescription) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      maxLines: isdescription ? 5 : 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        // labelText: "Enter Email",
        hintText: "${hint}",
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: const BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {},
      keyboardType: TextInputType.emailAddress,
    ),
  );
}
