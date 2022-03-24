import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/linkspace/addforum.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';

class ForumScreen extends StatefulWidget {
  final String id;
  const ForumScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final feeds = FirebaseFirestore.instance.collection('Feeds');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: feeds.where('feedtype', isEqualTo: widget.id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            const Loading();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            var feedinfo = snapshot.data!.docs;

            if (feedinfo.isEmpty) {
              return Stack(children: [
                const Center(
                    child: Image(image: AssetImage("assets/nofeed.png"))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: SpeedDial(
                        animatedIcon: AnimatedIcons.menu_home,
                        children: [
                          SpeedDialChild(
                              backgroundColor:
                                  const Color.fromRGBO(66, 103, 178, 1),
                              label: "Post",
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Addforum(id: widget.id),
                                  ),
                                );
                              }),
                          SpeedDialChild(
                              backgroundColor:
                                  const Color.fromRGBO(66, 103, 178, 1),
                              label: "Open",
                              child:
                                  const Icon(Icons.add, color: Colors.white)),
                        ],
                      )),
                )
              ]);
            } else {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: ListView.builder(
                      itemCount: feedinfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.primaries[
                                                Random().nextInt(
                                                    Colors.primaries.length)],
                                            child: Text(
                                              feedinfo[index]['Name'][0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedinfo[index]['Name'],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              const Text(
                                                'Location',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        feedinfo[index]['date'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    feedinfo[index]['postbody'],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            feedinfo[index]['Likes']
                                                    .toString() +
                                                ' Likes',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text('5 Comments',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 0.2,
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(Icons.favorite,
                                            color: Colors.pink),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.comment,
                                          color:
                                              Color.fromRGBO(66, 103, 178, 1),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.report_rounded,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: SpeedDial(
                          animatedIcon: AnimatedIcons.menu_home,
                          children: [
                            SpeedDialChild(
                                backgroundColor:
                                    const Color.fromRGBO(66, 103, 178, 1),
                                label: "Post",
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Addforum(id: widget.id),
                                    ),
                                  );
                                }),
                            SpeedDialChild(
                                backgroundColor:
                                    const Color.fromRGBO(66, 103, 178, 1),
                                label: "Open",
                                child:
                                    const Icon(Icons.add, color: Colors.white)),
                          ],
                        )),
                  )
                ],
              );
            }
          }
          return Loading();
        });
  }
}
