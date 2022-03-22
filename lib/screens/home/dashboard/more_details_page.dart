import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:googlesolutionchallenge/widgets/loading_cards.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoreDetailsPage extends StatefulWidget {
  final String? title;
  final String postid;
  final String? chatid;
  final bool isRequest;
  const MoreDetailsPage({
    Key? key,
    this.title,
    required this.postid,
    this.chatid,
    this.isRequest = false,
  }) : super(key: key);

  @override
  State<MoreDetailsPage> createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
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

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
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
                                runSpacing: 0,
                                children: [
                                  // Post Type Chip
                                  Chip(
                                    avatar: Icon(
                                      snapshot.data!['post-type'] ==
                                              'job request'
                                          ? Icons.work_outline_rounded
                                          : snapshot.data!['post-type'] ==
                                                  'item request'
                                              ? Icons.category_rounded
                                              : Icons
                                                  .volunteer_activism_rounded,
                                      color: Colors.blue[800],
                                    ),
                                    label: Text(
                                      snapshot.data!['post-type'] ==
                                              'job request'
                                          ? 'Job Request'
                                          : snapshot.data!['post-type'] ==
                                                  'item request'
                                              ? 'Item Request'
                                              : 'Charity',
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: Colors.blue[50],
                                  ),

                                  // Accepted or Not Chip
                                  !(snapshot.data!['accepted-by'] ==
                                          user!.userid)
                                      ? Chip(
                                          avatar: const Icon(
                                            Icons.pending_actions_rounded,
                                            color: Colors.indigo,
                                          ),
                                          label: const Text(
                                            'Pending',
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: Colors.indigo[50],
                                        )
                                      : Container(),

                                  // Ongoing Chip
                                  (snapshot.data!['completion-status'] ==
                                              'ongoing' &&
                                          snapshot.data!['accepted-by'] ==
                                              user.userid)
                                      ? Chip(
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

                                  // Overdue Chip
                                  (DateTime.now().compareTo(DateTime.parse(snapshot
                                                      .data![
                                                          'expected-completion-time']
                                                      .toDate()
                                                      .toString())) >
                                                  0 &&
                                              snapshot.data![
                                                      'completion-status'] ==
                                                  'ongoing') &&
                                          snapshot.data!['accepted-by'] ==
                                              user.userid
                                      ? Chip(
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

                                  // Completed Chip
                                  (snapshot.data!['completion-status'] ==
                                              'completed' &&
                                          snapshot.data!['accepted-by'] ==
                                              user.userid)
                                      ? Chip(
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

                                  // Money Pending Chip
                                  (snapshot.data!['completion-status'] ==
                                              'completed' &&
                                          snapshot.data!['payment-status'] ==
                                              'pending' &&
                                          snapshot.data!['accepted-by'] ==
                                              user.userid)
                                      ? Chip(
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

                              // Given or Accepted By

                              !widget.isRequest
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Given By:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(66, 103, 178, 1),
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
                                      ],
                                    )
                                  : (snapshot.data!['accepted-by'] != '')
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Accepted By:',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    66, 103, 178, 1),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              snapshot
                                                  .data!['accepted-by-name'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                      : Container(),

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

                              // Waiting List if it is request and pending
                              widget.isRequest
                                  ? (snapshot.data!['accepted-by'] == '')
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Waiting List:',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    66, 103, 178, 1),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: snapshot
                                                    .data!['waiting-list']
                                                    .length,
                                                itemBuilder: ((context, index) {
                                                  return FutureBuilder<
                                                          DocumentSnapshot>(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Userdata')
                                                          .doc(snapshot.data![
                                                                  'waiting-list']
                                                              [index])
                                                          .get(),
                                                      builder:
                                                          ((context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const LoadingCard(
                                                            height: 50,
                                                          );
                                                        }

                                                        if (snapshot.hasData &&
                                                            !snapshot
                                                                .data!.exists) {
                                                          return const Text(
                                                              "Document does not exist");
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          return Card(
                                                            child: ListTile(
                                                              onTap: () {},
                                                              leading:
                                                                  CircleAvatar(
                                                                backgroundColor: Colors
                                                                        .primaries[
                                                                    Random().nextInt(Colors
                                                                        .primaries
                                                                        .length)],
                                                                child: Text(
                                                                  snapshot.data![
                                                                      'name'][0],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                  snapshot.data![
                                                                      'name']),
                                                              subtitle: Text(
                                                                  snapshot.data![
                                                                      'email']),
                                                              trailing:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.green[
                                                                        50],
                                                                child:
                                                                    IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .check_rounded),
                                                                  onPressed:
                                                                      () {},
                                                                  color: Colors
                                                                          .green[
                                                                      500],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return const LoadingCard(
                                                          height: 50,
                                                        );
                                                      }));
                                                })),
                                          ],
                                        )
                                      : Container()
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ],
                ),
              ),
              // Bottom Sheet
              DraggableScrollableSheet(
                minChildSize: 0.16,
                initialChildSize: 0.16,
                maxChildSize: 0.25,
                snap: true,
                snapSizes: const [0.16, 0.25],
                builder: ((context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        !widget.isRequest
                            ? Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 4,
                                children: [
                                  // Chat
                                  (snapshot.data!['accepted-by'] == user.userid)
                                      ? SizedBox(
                                          width: 175,
                                          child: OutlinedButton.icon(
                                            icon: const Icon(
                                              Icons.forum_rounded,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'Chat',
                                              style: TextStyle(),
                                            ),
                                            // TODO: Chat Navigation
                                            onPressed: () {},
                                          ),
                                        )
                                      : Container(),

                                  // Mark As Done
                                  (snapshot.data!['completion-status'] ==
                                              'completed' &&
                                          snapshot.data!['payment-status'] ==
                                              'pending' &&
                                          snapshot.data!['accepted-by'] ==
                                              user.userid)
                                      ? SizedBox(
                                          width: 175,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.attach_money_rounded,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'Request Pay',
                                              style: TextStyle(),
                                            ),
                                            // TODO: Pay Request
                                            onPressed: () {},
                                          ),
                                        )
                                      : (snapshot.data!['accepted-by'] ==
                                              user.userid)
                                          ? SizedBox(
                                              width: 175,
                                              child: ElevatedButton.icon(
                                                icon: const Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  size: 20,
                                                ),
                                                label: const Text(
                                                  'Mark As Done',
                                                  style: TextStyle(),
                                                ),
                                                // Complete Request
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Confirmation",
                                                          ),
                                                          content: const Text(
                                                            "Are you sure you want to mark the request as complete?",
                                                          ),
                                                          actions: <Widget>[
                                                            OutlinedButton(
                                                              child: const Text(
                                                                  "Yes"),
                                                              onPressed:
                                                                  () async {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Posts')
                                                                    .doc(widget
                                                                        .postid)
                                                                    .set(
                                                                  {
                                                                    'completion-status':
                                                                        'completed',
                                                                  },
                                                                  SetOptions(
                                                                    merge: true,
                                                                  ),
                                                                ).then((value) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.check_rounded,
                                                                            color:
                                                                                Colors.green[800],
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Request marked as complete',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.green[800],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green[50],
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      elevation:
                                                                          3,
                                                                    ),
                                                                  );
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            ElevatedButton(
                                                              child: const Text(
                                                                  "No"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                        );
                                                      });
                                                },
                                              ),
                                            )
                                          : Container(),
                                  // TODO: Will do later, drive to the location

                                  /* SizedBox(
                                    width: 175,
                                    child: OutlinedButton.icon(
                                      icon: Icon(
                                        snapshot.data!['accepted-by'] ==
                                                user.userid
                                            ? Icons.directions_car_rounded
                                            : Icons.navigation_rounded,
                                        size: 20,
                                      ),
                                      label: Text(
                                        snapshot.data!['accepted-by'] ==
                                                user.userid
                                            ? 'Drive'
                                            : 'Location',
                                      ),
                                      onPressed: () {},
                                    ),
                                  ), */
                                  SizedBox(
                                    width: 175,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(
                                            250, 103, 117, 1),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Withdraw',
                                        style: TextStyle(),
                                      ),
                                      // Withdraw Request
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Confirmation",
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to withdraw your name from the request?",
                                                ),
                                                actions: <Widget>[
                                                  OutlinedButton(
                                                    child: const Text("Yes"),
                                                    onPressed: () async {
                                                      Map<String, dynamic>
                                                          json = {};
                                                      json['waiting-list'] =
                                                          FieldValue
                                                              .arrayRemove([
                                                        user.userid
                                                      ]);
                                                      if (user.userid ==
                                                          snapshot.data![
                                                              'accepted-by']) {
                                                        json['accepted-by'] =
                                                            '';
                                                        json['accepted-by-name'] =
                                                            '';
                                                        json['chat-id'] = '';
                                                      }

                                                      FirebaseFirestore.instance
                                                          .collection('Posts')
                                                          .doc(widget.postid)
                                                          .set(
                                                            json,
                                                            SetOptions(
                                                              merge: true,
                                                            ),
                                                          )
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .check_rounded,
                                                                  color: Colors
                                                                          .green[
                                                                      800],
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Successfully Removed',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .green[
                                                                        800],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 2),
                                                            backgroundColor:
                                                                Colors
                                                                    .green[50],
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            elevation: 3,
                                                          ),
                                                        );
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                              );
                                            });
                                      },
                                    ),
                                  )
                                ],
                              )
                            : Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 1,
                                children: [
                                  // Chat
                                  (snapshot.data!['given-by'] == user.userid)
                                      ? SizedBox(
                                          width: 175,
                                          child: OutlinedButton.icon(
                                            icon: Icon(
                                              Icons.forum_rounded,
                                              color: snapshot.data![
                                                          'accepted-by'] !=
                                                      ""
                                                  ? null
                                                  : Colors.grey[400],
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Chat',
                                              style: TextStyle(
                                                color: snapshot.data![
                                                            'accepted-by'] !=
                                                        ""
                                                    ? null
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                            onPressed:
                                                snapshot.data!['accepted-by'] !=
                                                        ""
                                                    ? () {}
                                                    : null,
                                          ),
                                        )
                                      : Container(),
                                  (snapshot.data!['given-by'] == user.userid)
                                      ? SizedBox(
                                          width: 175,
                                          child: OutlinedButton.icon(
                                            icon: Icon(
                                              Icons.edit_rounded,
                                              color: snapshot.data![
                                                          'completion-status'] ==
                                                      'ongoing'
                                                  ? null
                                                  : Colors.grey[400],
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Edit Request',
                                              style: TextStyle(
                                                color: snapshot.data![
                                                            'completion-status'] ==
                                                        'ongoing'
                                                    ? null
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                            onPressed: snapshot.data![
                                                        'completion-status'] ==
                                                    'ongoing'
                                                ? () {}
                                                : null,
                                          ),
                                        )
                                      : Container(),
                                  // Payment
                                  (snapshot.data!['completion-status'] ==
                                              'completed' &&
                                          snapshot.data!['payment-status'] ==
                                              'pending' &&
                                          snapshot.data!['given-by'] ==
                                              user.userid)
                                      ? SizedBox(
                                          width: 175,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.attach_money_rounded,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'Pay Now',
                                              style: TextStyle(),
                                            ),
                                            onPressed: () {},
                                          ),
                                        )
                                      : Container(),

                                  SizedBox(
                                    width: 175,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(
                                            250, 103, 117, 1),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(),
                                      ),
                                      onPressed: () {
                                        // TODO: Remove from waiting list and accepted-by
                                        // TODO: Show a dialog to confirm
                                        // TODO: Navigate to dashboard with a message
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
      /* floatingActionButton: FittedBox(
        child: 
      ), */
    );
  }
}
