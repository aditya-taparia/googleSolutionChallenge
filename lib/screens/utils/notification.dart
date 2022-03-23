import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:googlesolutionchallenge/widgets/loading_cards.dart';
import 'package:provider/provider.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool showcontainer = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Userdata')
              .doc(user!.userid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const LoadingCard();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingCard();
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!["notifications"].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: Text(snapshot.data!["notifications"]
                            [index.toString()][0]),
                        subtitle: Text(
                          snapshot.data!["notifications"][index.toString()][1],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: StatefulBuilder(builder: (context, setState) {
                          return Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showcontainer = true;
                                  });
                                },
                              ),
                              showcontainer
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.white,
                                        width: 80,
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Delete"),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  showcontainer = false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text("")
                            ],
                          );
                        }));
                  });
            }
            return Loading();
          }),
    );
  }
}
