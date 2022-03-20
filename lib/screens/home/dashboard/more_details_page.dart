import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:intl/intl.dart';

// TODO: Add Location Details

class MoreDetailsPage extends StatefulWidget {
  final String? title;
  final String postid;
  final String? chatid;
  const MoreDetailsPage({
    Key? key,
    this.title,
    required this.postid,
    this.chatid,
  }) : super(key: key);

  @override
  State<MoreDetailsPage> createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'More Details'),
      ),
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("Document does not exist"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          snapshot.data!['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(250, 103, 117, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(66, 103, 178, 1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        snapshot.data!['description'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),

                      // Tags
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          (snapshot.data!['completion-status'] == 'ongoing')
                              ? Chip(
                                  labelPadding: const EdgeInsets.only(
                                    right: 8.0,
                                    left: 4.0,
                                  ),
                                  avatar: const Icon(
                                    Icons.pending_actions_rounded,
                                    color: Colors.orange,
                                  ),
                                  label: const Text(
                                    'Ongoing',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.orange[50],
                                )
                              : Container(),
                          (DateTime.now().compareTo(DateTime.parse(snapshot
                                          .data!['expected-completion-time']
                                          .toDate()
                                          .toString())) >
                                      0 &&
                                  snapshot.data!['completion-status'] ==
                                      'ongoing')
                              ? Chip(
                                  labelPadding: const EdgeInsets.only(
                                    right: 8.0,
                                    left: 4.0,
                                  ),
                                  avatar: const Icon(
                                    Icons.schedule_rounded,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Overdue',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red[50],
                                )
                              : Container(),
                          (snapshot.data!['completion-status'] == 'completed')
                              ? Chip(
                                  labelPadding: const EdgeInsets.only(
                                    right: 8.0,
                                    left: 2.0,
                                  ),
                                  avatar: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.green,
                                  ),
                                  label: const Text(
                                    'Completed',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.green[50],
                                )
                              : Container(),
                          (snapshot.data!['completion-status'] == 'completed' &&
                                  snapshot.data!['payment-status'] == 'pending')
                              ? Chip(
                                  labelPadding: const EdgeInsets.only(
                                    right: 8.0,
                                    left: 2.0,
                                  ),
                                  avatar: const Icon(
                                    Icons.attach_money_rounded,
                                    color: Colors.purple,
                                  ),
                                  label: const Text(
                                    'Payment Pending',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.purple[50],
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Expected Completion Date
                      const Text(
                        'Expected Completion Date:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(66, 103, 178, 1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd MMMM yyyy').format(snapshot
                            .data!['expected-completion-time']
                            .toDate()),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),

                      // Given By
                      const Text(
                        'Given By:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(66, 103, 178, 1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        snapshot.data!['given-by-name'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),

                      // Promised Amount
                      const Text(
                        'Promised Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(66, 103, 178, 1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '₹ ${snapshot.data!['promised-amount'].toString()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(175, 40),
              ),
              icon: const Icon(
                Icons.forum_rounded,
                size: 20,
              ),
              label: const Text(
                'Chat',
                style: TextStyle(),
              ),
              onPressed: () {},
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(175, 40),
              ),
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
              ),
              label: const Text(
                'Mark As Done',
                style: TextStyle(),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
