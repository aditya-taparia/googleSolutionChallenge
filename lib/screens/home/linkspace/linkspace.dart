import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:googlesolutionchallenge/screens/home/linkspace/addlinkspace.dart';
import 'package:googlesolutionchallenge/screens/home/chat/forum.dart';
import 'package:googlesolutionchallenge/screens/utils/randomcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user.dart';
import '../../../widgets/loading.dart';

class Linkspace extends StatefulWidget {
  const Linkspace({Key? key}) : super(key: key);

  @override
  State<Linkspace> createState() => _LinkspaceState();
}

bool _isspaceowned = true;

late Color prevcolor;
late bool docexist = true;

List<String> tiletitles = [
  "Indian Institute Of Information Technology",
];
List<String> tiledescriptions = [
  "A linkspace dedicated to study flutter and develop futuristic apps for the betterment of the world",
];

List<String> tilelocation = [
  "Valavoor, Kottayam",
];
List<int> tilememeber = [546];

class _LinkspaceState extends State<Linkspace> {
  @override
  late bool view = false;

  CollectionReference Linkspacecollection =
      FirebaseFirestore.instance.collection('Linkspace');
// all data
  Future<List<Object?>> getData() async {
    QuerySnapshot querySnapshot = await Linkspacecollection.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }

  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    print(getData());
    final Stream<DocumentSnapshot> _Linkspacestream =
        Linkspacecollection.doc(user!.userid).snapshots();

    /*Linkspacecollection.doc(user.userid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print("exist");
        setState(() {
          docexist = true;
        });
      } else {
        setState(() {
          docexist = false;
        });
      }
    });*/

    return docexist
        ? StreamBuilder<DocumentSnapshot>(
            stream: _Linkspacestream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Object?>> linkspaceSnapshot) {
              if (linkspaceSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Loading();
              }
              if (linkspaceSnapshot.hasData) {
                tiletitles.add(linkspaceSnapshot.data!['name']);
                tiledescriptions.add(linkspaceSnapshot.data!['description']);
                tilelocation.add(linkspaceSnapshot.data!['location']);
                tilememeber.add(linkspaceSnapshot.data!['member'].length);
                return Scaffold(
                  // appBar: AppBar(),
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Linkspace",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Row(
                                children: [
                                  Text('Show Nearby Spaces'),
                                  Switch(
                                    value: !_isspaceowned,
                                    onChanged: (bool active) {
                                      setState(() {
                                        view = active;
                                        _isspaceowned = !_isspaceowned;
                                      });
                                    },
                                    activeColor:
                                        const Color.fromRGBO(66, 103, 178, 1),
                                    inactiveTrackColor: Colors.grey,
                                    inactiveThumbColor: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: _isspaceowned
                                ? const Text(
                                    "Check out what happening in your space",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  )
                                : const Text(
                                    "Explore and find your ideal space",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: tiletitles.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Color color = Randomcol().getcolor();
                                if (index == 0) {
                                  prevcolor = color;
                                } else {
                                  if (prevcolor == color) {
                                    color = setnewcolor(color, prevcolor);
                                  }
                                  prevcolor = color;
                                }

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Forum()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 240,
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: const BorderRadius.all(
                                              // topLeft: Radius.circular(10),
                                              Radius.circular(15))),
                                      padding: const EdgeInsets.all(4.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 92, 216, 96),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: const [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Text(
                                                          "Active",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        tilelocation[index],
                                                        style: TextStyle(
                                                          color: color,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ListTile(
                                              leading: Column(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 8, 7),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Column(
                                                      children: [
                                                        const Icon(Icons.group),
                                                        Text(
                                                          tilememeber[index]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: color,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  tiletitles[(index)],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                    tiledescriptions[index],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13)),
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.chat,
                                                        color: Colors.white,
                                                      ),
                                                      Icon(
                                                        Icons.forum,
                                                        color: Colors.white,
                                                      ),
                                                      Icon(
                                                        Icons.handshake,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        onPrimary: Colors.white,
                                                        // shadowColor: Colors.red,
                                                        elevation: 0,
                                                      ),
                                                      onPressed: _isspaceowned
                                                          ? () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const Forum()));
                                                            }
                                                          : () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Send Request",
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                        "Purpose of joining the LinkSpace?",
                                                                      ),
                                                                      TextFormField(
                                                                        autofocus:
                                                                            false,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        onSaved:
                                                                            (value) {},
                                                                        textInputAction:
                                                                            TextInputAction.done,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          fillColor:
                                                                              Colors.white,
                                                                          filled:
                                                                              true,
                                                                          prefixIcon:
                                                                              Icon(Icons.group),
                                                                          contentPadding: EdgeInsets.fromLTRB(
                                                                              20,
                                                                              15,
                                                                              20,
                                                                              15),
                                                                          hintText:
                                                                              "Answer",
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    OutlinedButton(
                                                                      child: const Text(
                                                                          "Send"),
                                                                      onPressed:
                                                                          () {},
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: const Text(
                                                                          "Exit"),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                  actionsAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                ),
                                                              );
                                                            },
                                                      child: _isspaceowned
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Icon(
                                                                  Icons.check,
                                                                  color: color,
                                                                ),
                                                                Text(
                                                                  "Joined",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        GoogleFonts.varelaRound()
                                                                            .fontFamily,
                                                                    color:
                                                                        color,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                )
                                                              ],
                                                            )
                                                          : Text(
                                                              "Join this space",
                                                              style: TextStyle(
                                                                fontFamily: GoogleFonts
                                                                        .varelaRound()
                                                                    .fontFamily,
                                                                color: color,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            )),
                                                ),
                                                _isspaceowned
                                                    ? const Icon(
                                                        Icons.notifications,
                                                        color: Colors.white,
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),

                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Addlinkspace()));
                    },
                    child: const Icon(Icons.group_add),
                  ),
                );
              }
              return const Loading();
            },
          )
        : Scaffold(
            body: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("LinkSpace",
                          style: TextStyle(
                              color: Color.fromRGBO(66, 103, 178, 1),
                              fontSize: 25)),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.info_rounded,
                        color: Colors.grey,
                        size: 20,
                      )
                    ],
                  ),
                ),
                Lottie.asset('assets/team.json'),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Find Your LinkSpaces")),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Addlinkspace()));
              },
              child: const Icon(Icons.group_add),
            ),
          );
  }
}

Color setnewcolor(Color color, Color prevcolor) {
  color = Randomcol().getcolor();
  if (color == prevcolor) {
    setnewcolor(color, prevcolor);
  }
  return color;
}
