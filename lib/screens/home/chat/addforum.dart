import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';

class Addforum extends StatefulWidget {
  final String id;
  const Addforum({Key? key, required this.id}) : super(key: key);

  @override
  _AddforumState createState() => _AddforumState();
}

class _AddforumState extends State<Addforum> {
  final _feedcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
        .collection('Userdata')
        .doc(user!.userid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (userSnapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Share Post"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          child: Text(
                            userSnapshot.data!['name'][0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userSnapshot.data!['name'],
                              style: TextStyle(fontSize: 18),
                            ),
                            const Text(
                              'Location',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      //  color: Colors.black,
                      child: TextField(
                        controller: _feedcontroller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Post',
                          hintText: 'What do you want to talk about ?',
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Add Hashtag",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  sendpost(
                      _feedcontroller, user.userid, userSnapshot.data!['name']);
                  _feedcontroller.clear();
                  Navigator.pop(context);
                },
                child: Icon(Icons.done),
              ),
            );
          }
          return const Loading();
        });
  }

  Future sendpost(
      TextEditingController feedcontroller, String userid, param2) async {
    final feed = FirebaseFirestore.instance.collection("Feeds").doc();
    final json = {
      'Likes': 0,
      'Name': param2,
      'date': "1/1/1",
      'feedtype': widget.id,
      'ownerid': userid,
      'postbody': feedcontroller.text,
      'title': "default"
    };

    await feed.set(json);
  }
}
