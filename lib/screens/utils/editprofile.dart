import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:googlesolutionchallenge/models/user.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final textcontroller = TextEditingController();
  final textcontroller1 = TextEditingController();
  final textcontroller2 = TextEditingController();
  final textcontroller3 = TextEditingController();

  @override
  void dispose() {
    textcontroller.dispose();
    textcontroller1.dispose();
    textcontroller2.dispose();
    textcontroller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Userdata')
            .doc(user!.userid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> UserSnapShot) {
          if (UserSnapShot.hasError) {
            return Text("Something went wrong");
          }

          if (UserSnapShot.hasData && !UserSnapShot.data!.exists) {
            return Text("Document does not exist");
          }

          if (UserSnapShot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (UserSnapShot.hasData) {
            String finalname = UserSnapShot.data!['name'];
            String finalemail = UserSnapShot.data!['email'];
            String finaldescription = UserSnapShot.data!['description'];
            textcontroller.text = UserSnapShot.data!['name'];
            textcontroller1.text = UserSnapShot.data!['email'];
            textcontroller2.text = UserSnapShot.data!['description'];

            textcontroller.selection = TextSelection(
                baseOffset: UserSnapShot.data!['name'].length,
                extentOffset: UserSnapShot.data!['name'].length);
            textcontroller1.selection = TextSelection(
                baseOffset: UserSnapShot.data!['email'].length,
                extentOffset: UserSnapShot.data!['email'].length);
            textcontroller2.selection = TextSelection(
                baseOffset: UserSnapShot.data!['description'].length,
                extentOffset: UserSnapShot.data!['description'].length);

            return GestureDetector(
              onTap: (() => FocusScope.of(context).unfocus()),
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 38.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text('Name'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(66, 103, 178, 1),
                                  width: 1.75,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                  width: 1.5,
                                ),
                              ),
                              enabled: true,
                              floatingLabelStyle: const TextStyle(
                                color: Color.fromRGBO(66, 103, 178, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                              alignLabelWithHint: true,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            key: Key(UserSnapShot.data!['name']),
                            initialValue: UserSnapShot.data!['name'],
                            onChanged: (value) {
                              if (value != '') finalname = value;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 38.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text('Email'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(66, 103, 178, 1),
                                  width: 1.75,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                  width: 1.5,
                                ),
                              ),
                              enabled: true,
                              floatingLabelStyle: const TextStyle(
                                color: Color.fromRGBO(66, 103, 178, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                              alignLabelWithHint: true,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            key: Key(UserSnapShot.data!['email']),
                            initialValue: UserSnapShot.data!['email'],
                            onChanged: (value) {
                              if (value != '') finalemail = value;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 18.0),
                          child: TextFormField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              label: const Text('Description'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(66, 103, 178, 1),
                                  width: 1.75,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                  width: 1.5,
                                ),
                              ),
                              enabled: true,
                              floatingLabelStyle: const TextStyle(
                                color: Color.fromRGBO(66, 103, 178, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                              alignLabelWithHint: true,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            key: Key(UserSnapShot.data!['description']),
                            initialValue: UserSnapShot.data!['description'],
                            onChanged: (value) {
                              if (value != '') finaldescription = value;
                            },
                          )),
                      ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            addtodb(user.userid, finalname, finalemail,
                                finaldescription);
                          },
                          child: Text(
                            'Save ',
                            style: TextStyle(
                              fontFamily: GoogleFonts.varelaRound().fontFamily,
                            ),
                          ))
                    ],
                  )),
                ),
              ),
            );
          }
          return Loading();
        });
  }
}

Future addtodb(
    String userid, String name, String email, String description) async {
  final db = FirebaseFirestore.instance.collection('Userdata').doc(userid);
  final json = {'name': name, 'email': email, 'description': description};
  await db.set(json, SetOptions(merge: true));
}
