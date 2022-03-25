import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/individualchat.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final NavigationBloc bloc;
  const ChatScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<QuerySnapshot<Object?>> _usersStream =
        FirebaseFirestore.instance.collection('chats').where('users', arrayContains: user!.userid).snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (userSnapshot.hasData) {
            var data = userSnapshot.data!.docs as List;

            if (data.isEmpty) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/nochat.png")),
                    const Text(
                      'No chats',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.bloc.changeNavigationIndex(Navigation.map);
                        },
                        child: const Text("Roam the neighbourhood"),
                      ),
                    )
                  ],
                ),
              );
            } else {
              List chatList = [];
              data.forEach((element) {
                chatList.add(element);
                //  print(element.id);
              });
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final chat = chatList[index].data();
                      Color randomcolor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                      Map sender;
                      int read;
                      if (chat["name"][0]["id"] == user.userid.toString()) {
                        sender = chat["name"][1];
                        read = chat["read"][0];
                      } else {
                        sender = chat["name"][0];
                        read = chat["read"][1];
                      }

                      // String img = sender["imgUrl"];
                      //print(sender);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IndividualChat(id: chatList[index].id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: read > 0 ? const Color.fromRGBO(66, 103, 178, 0.29) : Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
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
                                      radius: 25,
                                      backgroundColor: randomcolor,
                                      child: Text(
                                        sender["name"][0].toString().toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sender["name"],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: const Text(
                                            "Hii There !!!",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 15, color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "12:30",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    read > 0
                                        ? Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30)),
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
                        ),
                      );
                    }),
              );
            }
          } else {
            return const Loading();
          }
        });
  }
}
