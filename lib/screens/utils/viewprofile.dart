import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:googlesolutionchallenge/widgets/loading.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color randomcolor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Userdata').doc(widget.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> userSnapShot) {
          if (userSnapShot.hasError) {
            return const Text("Something went wrong");
          }

          if (userSnapShot.hasData && !userSnapShot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (userSnapShot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (userSnapShot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButton(
                    color: Colors.black,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: randomcolor,
                        child: Text(
                          userSnapShot.data!['name'][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Text(
                          "${userSnapShot.data!['name']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "${userSnapShot.data!['email']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${userSnapShot.data!['points']}',
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Link Points',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: const [
                              Text(
                                '15',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tasks Completed',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description :',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${userSnapShot.data!['description']}',
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return const Loading();
        });
  }
}
