import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/sample.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class IndividualChat extends StatefulWidget {
  const IndividualChat({Key? key, required this.user, required this.id})
      : super(key: key);
  final Map user;
  final String id;

  @override
  _IndividualChatState createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  final _msgcontroller = TextEditingController();

  Future ReadMsg(String id, int read) async {
    final linkspace = FirebaseFirestore.instance.collection("chats").doc(id);
    linkspace.update({
      "read": [0, read]
    });
  }

  buildMessage(String message, Timestamp time, bool isUser) {
    DateTime d = time.toDate();
    // var dt = DateTime.fromMillisecondsSinceEpoch(d);
// 12 Hour format:
    var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(d);
    return Container(
      margin: isUser
          ? const EdgeInsets.only(top: 10, bottom: 8, left: 80)
          : const EdgeInsets.only(top: 10, bottom: 8, right: 80),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: isUser
            ? const Color.fromRGBO(66, 103, 178, 1)
            : const Color.fromARGB(255, 235, 232, 232),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              d12,
              style: TextStyle(
                  color: !isUser ? Colors.grey : Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  buildMessageComposer(String userid, length, read) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.photo),
          iconSize: 30,
          color: Theme.of(context).primaryColor,
        ),
        Expanded(
            child: TextField(
          controller: _msgcontroller,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {},
          decoration: const InputDecoration.collapsed(
            hintText: 'Send a message',
          ),
        )),
        IconButton(
          onPressed: () {
            print(_msgcontroller.text);

            String msg = _msgcontroller.text;
            addmsgDB(msg, widget.id, userid, length, read);
            _msgcontroller.clear();
          },
          icon: const Icon(Icons.send),
          iconSize: 30,
          color: Theme.of(context).primaryColor,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot.data!['chatdata']);
            Map data = snapshot.data!['chatdata'];
            Map sender;
            int read;
            if (snapshot.data!["name"][0]["id"] == user!.userid.toString()) {
              sender = snapshot.data!["name"][1];
              read = snapshot.data!["read"][1];
            } else {
              sender = snapshot.data!["name"][0];
              read = snapshot.data!["read"][0];
            }
            ReadMsg(widget.id, read);
            return Scaffold(
              backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
              appBar: AppBar(
                title: Text(sender["name"]),
                elevation: 0,
              ),
              body: GestureDetector(
                onTap: (() => FocusScope.of(context).unfocus()),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: ListView.builder(
                              padding: const EdgeInsets.only(top: 15),
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(data[index.toString()]);

                                final bool isUser =
                                    data[index.toString()][0] == user.userid;
                                return buildMessage(data[index.toString()][1],
                                    data[index.toString()][2], isUser);
                              }),
                        ),
                      ),
                    ),
                    buildMessageComposer(
                        user.userid, snapshot.data!['chatdata'].length, read),
                  ],
                ),
              ),
            );
          } else {
            return Text("kuch nhi hua");
          }
        });
  }

  Future addmsgDB(String msg, String id, userid, length, read) async {
    final linkspace = FirebaseFirestore.instance.collection("chats").doc(id);
    var time = DateTime.now();

    linkspace.set({
      "chatdata": {
        length.toString(): [userid, msg, time]
      }
    }, SetOptions(merge: true));
    ReadMsg(id, read + 1);
  }
}
