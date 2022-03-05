import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/individualchat.dart';
import 'package:googlesolutionchallenge/screens/home/chat/sample.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Userdata')
        .doc(user!.userid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (userSnapshot.hasData) {
            print(userSnapshot.data.toString());
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                  itemCount:
                      userSnapshot.data!['chat-id-list'].length ?? chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chat = userSnapshot.data!['chat-id-list'][index];
                    print(chat);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => IndividualChat(
                                    user: chat,
                                    curruser: {
                                      "recieverId": user.userid,
                                      "recieverName":
                                          userSnapshot.data!['name'],
                                      "imgUrl": ""
                                    },
                                  ))),
                      child: Container(
                        decoration: BoxDecoration(
                          color: false
                              ? const Color.fromRGBO(66, 103, 178, 0.29)
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/profile.png'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat!['recieverName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        "chat.text",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "chat.time",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                false
                                    ? Container(
                                        width: 40,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'NEW',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Loading();
          }
        });
  }
}
