import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
                        progressColor: Colors.green,
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
                Text('Welcome to LINK ', style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text("Get 'Linked' to us by creating an unique username",
                    style: TextStyle(fontSize: 15)),
                Textfielduse('UserName'),
                Textfielduse('Confirm Username'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 46, 164, 243),
                            onPrimary: Colors.white,
                            // shadowColor: Colors.red,
                            elevation: 5,
                          ),
                          onPressed: () {
                            continueStep();
                          },
                          child: Text(
                            "Continue",
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
      return Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
              child: Text(
                  'Our app mainly rely on location access to provide services so kindly grant location access',
                  style: TextStyle(fontSize: 18)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 46, 164, 243),
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
                    primary: Color.fromARGB(255, 46, 164, 243),
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
          ],
        ),
      );
    case 3:
      return Container(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 46, 164, 243),
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
                  primary: Color.fromARGB(255, 46, 164, 243),
                  onPrimary: Colors.white,
                  // shadowColor: Colors.red,
                  elevation: 5,
                ),
                onPressed: () {},
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    default:
      return Container();
  }
}

Widget Textfielduse(hint) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20.0),
          // labelText: "Enter Email",
          hintText: "${hint}",
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {},
        keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    ),
  );
}
