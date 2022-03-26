import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/services/image.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

// import 'package:image_picker/image_picker.dart';

class Linkspacechat extends StatefulWidget {
  final String id;
  const Linkspacechat({Key? key, required this.id}) : super(key: key);

  @override
  State<Linkspacechat> createState() => _LinkspacechatState();
}

class _LinkspacechatState extends State<Linkspacechat> {
  final _msgcontroller = TextEditingController();
  Map userList = {};
  bool scrollneeded = true;
  var photoUrl;
  final ImageData img = ImageData();

  Future<Map> getuserdata() async {
    final QuerySnapshot<Map<String, dynamic>> _usersStream = await FirebaseFirestore.instance.collection('Userdata').get();

    var temp = _usersStream.docs;

    for (var element in temp) {
      userList[element.id] = element['name'];
    }

    return userList;
  }

  buildMessageComposer(String userid, length) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.grey[50],
      child: Row(children: [
        IconButton(
          onPressed: () async {
            photoUrl = await img.takeMedia('linkspace/', "myimh");
            addmsgDB(photoUrl, widget.id, userid, length);
          },
          icon: const Icon(Icons.add_photo_alternate_rounded),
          iconSize: 30,
          color: const Color.fromRGBO(66, 103, 178, 1),
        ),
        Expanded(
            child: TextField(
          controller: _msgcontroller,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          decoration: const InputDecoration.collapsed(
            hintText: 'Send a message',
          ),
          cursorColor: const Color.fromRGBO(66, 103, 178, 1),
        )),
        IconButton(
          onPressed: () {
            String msg = _msgcontroller.text;
            addmsgDB(msg, widget.id, userid, length);
            _msgcontroller.clear();
          },
          icon: const Icon(Icons.send_rounded),
          iconSize: 30,
          color: const Color.fromRGBO(66, 103, 178, 1),
        ),
      ]),
    );
  }

  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    if (scrollneeded) _controller.jumpTo(_controller.position.maxScrollExtent);
    scrollneeded = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    return FutureBuilder<Map>(
        future: getuserdata(),
        builder: (context, userdata) {
          try {
            if (userdata.connectionState == ConnectionState.waiting) {
              return const Loading();
            }

            if (userdata.connectionState == ConnectionState.done) {
              if (!userdata.hasData) {
                return const Loading();
              }

              if (userdata.hasData) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('Linkspace').doc(widget.id).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Loading();
                      }
                      if (snapshot.connectionState == ConnectionState.active) {
                        return GestureDetector(
                          onTap: (() => FocusScope.of(context).unfocus()),
                          child: Scaffold(
                            body: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                                    child: ListView.builder(
                                        itemCount: snapshot.data!['groupchat'].length,
                                        controller: _controller,
                                        shrinkWrap: true,
                                        itemBuilder: ((context, index) {
                                          SchedulerBinding.instance!.addPostFrameCallback((_) => _scrollDown());

                                          return user!.userid == snapshot.data!['groupchat'][index.toString()][0]
                                              ? Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                          color: Color.fromRGBO(66, 103, 178, 1),
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        ),
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: ListTile(
                                                          title: Text(
                                                            snapshot.data!['groupchat'][index.toString()][1],
                                                            style: const TextStyle(color: Colors.white, fontSize: 18),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                          color: Color.fromARGB(255, 235, 232, 232),
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        ),
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: ListTile(
                                                          title: Text(
                                                            userList[snapshot.data!['groupchat'][index.toString()][0]],
                                                            style: const TextStyle(
                                                              color: Color.fromRGBO(66, 103, 178, 1),
                                                            ),
                                                          ),
                                                          subtitle: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: Text(
                                                              snapshot.data!['groupchat'][index.toString()][1],
                                                              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                        })),
                                  ),
                                ),
                                buildMessageComposer(user!.userid, snapshot.data!['groupchat'].length),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Loading();
                    });
              }
            }
          } catch (e) {
            rethrow;
          }
          return const Loading();
        });
  }

  Future addmsgDB(String msg, String id, userid, length) async {
    final linkspace = FirebaseFirestore.instance.collection("Linkspace").doc(id);

    linkspace.set({
      "groupchat": {
        length.toString(): [userid, msg]
      }
    }, SetOptions(merge: true));
  }
}
