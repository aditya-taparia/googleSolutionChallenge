import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';

class Linkspacechat extends StatefulWidget {
  final String id;
  const Linkspacechat({Key? key, required this.id}) : super(key: key);

  @override
  State<Linkspacechat> createState() => _LinkspacechatState();
}

class _LinkspacechatState extends State<Linkspacechat> {
  Map userList = {};

  Future<Map> getuserdata() async {
    final QuerySnapshot<Map<String, dynamic>> _usersStream =
        await FirebaseFirestore.instance.collection('Userdata').get();

    var temp = _usersStream.docs;

    temp.forEach((element) {
      userList[element.id] = element['name'];
    });

    return userList;
  }

  buildMessageComposer() {
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
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {},
          decoration: const InputDecoration.collapsed(
            hintText: 'Send a message',
          ),
        )),
        IconButton(
          onPressed: () {},
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

    return FutureBuilder<Map>(
        future: getuserdata(),
        builder: (context, userdata) {
          try {
            if (userdata.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (userdata.connectionState == ConnectionState.done) {
              if (userdata == null) {
                return Loading();
              }

              if (userdata.hasData) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Linkspace')
                        .doc(widget.id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Loading();
                      }
                      if (snapshot.connectionState == ConnectionState.active) {
                        return GestureDetector(
                          onTap: (() => FocusScope.of(context).unfocus()),
                          child: Scaffold(
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: ListView.builder(
                                      itemCount:
                                          snapshot.data!['groupchat'].length,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        return user!.userid ==
                                                snapshot.data!['groupchat']
                                                    [index.toString()][0]
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          66, 103, 178, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: ListTile(
                                                      title: Text(
                                                        snapshot.data![
                                                                'groupchat'][
                                                            index
                                                                .toString()][1],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 235, 232, 232),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: ListTile(
                                                      title: Text(
                                                        userList[snapshot.data![
                                                                    'groupchat']
                                                                [
                                                                index
                                                                    .toString()]
                                                            [0]],
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              66, 103, 178, 1),
                                                        ),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          snapshot.data![
                                                                  'groupchat'][
                                                              index
                                                                  .toString()][1],
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                      })),
                                ),
                                buildMessageComposer(),
                              ],
                            ),
                          ),
                        );
                      }
                      return Loading();
                    });
              }
            }
          } catch (e) {
            rethrow;
          }
          return Loading();
        });
  }
}
