import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/widgets/feed_card.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';

class DashFeed extends StatefulWidget {
  const DashFeed({Key? key}) : super(key: key);

  @override
  State<DashFeed> createState() => _DashFeedState();
}

class _DashFeedState extends State<DashFeed> {
  @override
  Widget build(BuildContext context) {
    final feeds = FirebaseFirestore.instance.collection('Feeds');
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body:
          // Feed Card
          StreamBuilder<QuerySnapshot>(
              stream: feeds.where('isOpen', isEqualTo: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (!snapshot.hasData) {
                  return Loading(); // change to vector image
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  var feedinfo = snapshot.data!.docs;
                  if (feedinfo.isEmpty) {
                    //return some vector image
                  } else {
                    return ListView.builder(
                        itemCount: feedinfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FeedCard(
                            leading: CircleAvatar(
                              backgroundColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              child: Text(
                                feedinfo[index]['Name'][0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: feedinfo[index]['title'],
                            subtitle: feedinfo[index]['Name'],
                            date: feedinfo[index]['date'],
                            description: feedinfo[index]['postbody'],
                            likes: feedinfo[index]['Likes'],
                            comments: 5,
                            actions: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_outline_rounded,
                                  color: Colors.pink,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.comment_rounded,
                                  color: Color.fromRGBO(66, 103, 178, 1),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.report_rounded,
                                ),
                              ),
                            ],
                          );
                        });
                  }
                }
                return Loading();
              }),
    );
  }
}
