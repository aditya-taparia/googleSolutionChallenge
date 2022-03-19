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
                        return Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: ListView.builder(
                                itemCount: snapshot.data!['groupchat'].length,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: ListTile(
                                                title: Text(userList[
                                                    snapshot.data!['groupchat']
                                                        [index.toString()][0]]),
                                                subtitle: Text(
                                                    snapshot.data!['groupchat']
                                                        [index.toString()][1]),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: ListTile(
                                                title: Text(userList[
                                                    snapshot.data!['groupchat']
                                                        [index.toString()][0]]),
                                                subtitle: Text(
                                                    snapshot.data!['groupchat']
                                                        [index.toString()][1]),
                                              ),
                                            ),
                                          ],
                                        );
                                })),
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
