import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/main.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/services/userdatabase.dart';
import 'package:googlesolutionchallenge/widgets/form_widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<String> arr = [
    'Set Name & Email',
    'Permissions',
    'Terms & Conditions',
  ];
  String s = 'Finish';
  bool isusername = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool agree = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user!.email != null) {
      setState(() {
        emailController.text = user.email.toString();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircularPercentIndicator(
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
                            color: Color.fromRGBO(66, 103, 178, 1),
                          ),
                        ),
                        animation: true,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arr[current - 1],
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                const SizedBox(
                  height: 30,
                ),
                switchcase(
                  current,
                  continueStep,
                  previousStep,
                  context,
                  nameController,
                  emailController,
                  user.userid,
                  formKey,
                  agree,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget switchcase(value, continueStep, previousStep, BuildContext context, TextEditingController nameController,
    TextEditingController emailController, String userid, GlobalKey<FormState> formKey, bool _agree) {
  switch (value) {
    case 1:
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Welcome to LINK',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(66, 103, 178, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Get Linked to us by creating an username",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputField(
                    label: 'Username',
                    controller: nameController,
                    autoFocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please set a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextInputField(
                    label: 'Email Address',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autoFocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please set an email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            continueStep();
                          }
                        },
                        child: const Text('Create & Continue'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    case 2:
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Allow these for the best app experience',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[50],
              child: const Icon(
                Icons.person_pin_circle_rounded,
                size: 30,
                color: Color.fromRGBO(66, 103, 178, 1),
              ),
            ),
            title: const Text(
              'Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text('Allow us to access your location'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red[50],
              child: const Icon(
                Icons.photo_camera_rounded,
                size: 30,
                color: Colors.pink,
              ),
            ),
            title: const Text(
              'Camera',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text('Allow us to access your camera'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green[50],
              child: const Icon(
                Icons.storage_rounded,
                size: 30,
                color: Colors.green,
              ),
            ),
            title: const Text(
              'Storage',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text('Allow us to access your storage'),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: const Color.fromRGBO(66, 103, 178, 1),
                  ),
                  onPressed: () {
                    previousStep();
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(66, 103, 178, 1),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    List<String> pending = [];
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.location,
                      Permission.camera,
                      Permission.storage,
                      //add more permission to request here.
                    ].request();
                    if (statuses[Permission.location]!.isDenied) {
                      pending.add('Location');
                    }
                    if (statuses[Permission.camera]!.isDenied) {
                      pending.add('Camera');
                    }
                    if (statuses[Permission.storage]!.isDenied) {
                      pending.add('Storage');
                    }
                    if (statuses[Permission.location]!.isGranted &&
                        statuses[Permission.camera]!.isGranted &&
                        statuses[Permission.storage]!.isGranted) {
                      continueStep();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: Colors.red[800],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  'Please grant ${pending.join(', ')} permission to continue',
                                  style: TextStyle(
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red[50],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Allow & Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ],
      );

    case 3:
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              // Checkbox CheckboxTile
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color.fromRGBO(66, 103, 178, 1),
                title: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'I Agree to the Terms & Conditions',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Please take a moment to review the Terms and Conditions. By checking this box, you will be agreeing to the terms and conditions of the app.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                value: _agree,
                onChanged: (value) {
                  setState(() {
                    _agree = value!;
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: const Color.fromRGBO(66, 103, 178, 1),
                      ),
                      onPressed: () {
                        previousStep();
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(66, 103, 178, 1),
                        onSurface: Colors.grey,
                        elevation: 5,
                      ),
                      onPressed: !_agree
                          ? null
                          : () async {
                              UserDatabaseService(uid: userid).setUserData(nameController.text, emailController.text);
                              if (kDebugMode) {
                                print("Shared pref called");
                              }
                              int isstep = 0;
                              SharedPreferences prefs = await SharedPreferences.getInstance();
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
                        "Finish",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ],
          );
        },
      );
    default:
      return Container();
  }
}
