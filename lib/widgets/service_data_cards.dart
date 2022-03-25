import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/more_details_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: Tags for pending, completed, ongoing And hide the chat and mark as
// completed button if the service is pending And show request pay button when
// the service is completed

class ServiceDataCard extends StatelessWidget {
  final String title;
  final String description;
  final String postid;
  final String chatid;
  final Timestamp expectedCompletionDate;
  final String status;
  final String givenBy;
  final double amount;
  final bool isAccepted;
  final String paymentStatus;
  final String postType;

  const ServiceDataCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.chatid,
    required this.description,
    required this.expectedCompletionDate,
    required this.givenBy,
    required this.postid,
    required this.status,
    required this.isAccepted,
    required this.paymentStatus,
    required this.postType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return FittedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Card(
          color: isAccepted ? Colors.grey[50] : Colors.white,
          elevation: 2.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(66, 103, 178, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(primary: Colors.grey[600]),
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Details',
                        style: TextStyle(),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreDetailsPage(
                              title: 'Service Details',
                              postid: postid,
                              chatid: chatid,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Description
                SizedBox(
                  height: 50,
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Tags
                FittedBox(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 1,
                    children: [
                      // Item Request, Job Request or Charity Chip
                      Chip(
                        avatar: Icon(
                          postType == 'job request'
                              ? Icons.work_outline_rounded
                              : postType == 'item request'
                                  ? Icons.category_rounded
                                  : Icons.volunteer_activism_rounded,
                          color: Colors.blue[800],
                        ),
                        label: Text(
                          postType == 'job request'
                              ? 'Job Request'
                              : postType == 'item request'
                                  ? 'Item Request'
                                  : 'Charity',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.blue[50],
                      ),
                      // Accepted Chip
                      !isAccepted
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
                          : const SizedBox(height: 0, width: 0),

                      // Ongoing Chip
                      status == 'ongoing' && isAccepted
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
                          : const SizedBox(height: 0, width: 0),

                      // Overdue Chip
                      DateTime.now().compareTo(DateTime.parse(expectedCompletionDate.toDate().toString())) > 0 && status == 'ongoing' && isAccepted
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
                          : const SizedBox(height: 0, width: 0),

                      // Completed Chip
                      status == 'completed' && isAccepted
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
                          : const SizedBox(height: 0, width: 0),

                      // Payment Completed Chip
                      status == 'completed' && paymentStatus == 'pending' && isAccepted
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
                          : const SizedBox(height: 0, width: 0),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // Expected Completion Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Expected Completion Date:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('dd-MM-yyyy').format(expectedCompletionDate.toDate()),
                      //expectedCompletionDate.toDate().toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Given By
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Given By:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      givenBy,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Promised Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Promised Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '₹ ${amount.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Chat Button And [Mark As Done] Button
                FittedBox(
                  child: isAccepted
                      ? Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
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
                                // TODO: Chat Navigation
                                onPressed: () {},
                              ),
                              status == 'ongoing'
                                  ? ElevatedButton.icon(
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
                                      // Mark As Done
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
                                                    child: const Text("Yes"),
                                                    onPressed: () async {
                                                      FirebaseFirestore.instance.collection('Posts').doc(postid).set(
                                                        {
                                                          'completion-status': 'completed',
                                                        },
                                                        SetOptions(
                                                          merge: true,
                                                        ),
                                                      ).then((value) {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  Icons.check_rounded,
                                                                  color: Colors.green[800],
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  'Request marked as complete',
                                                                  style: TextStyle(
                                                                    color: Colors.green[800],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            duration: const Duration(seconds: 2),
                                                            backgroundColor: Colors.green[50],
                                                            behavior: SnackBarBehavior.floating,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
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
                                                actionsAlignment: MainAxisAlignment.spaceAround,
                                              );
                                            });
                                      },
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(175, 40),
                                      ),
                                      icon: const Icon(
                                        Icons.attach_money_rounded,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Request Pay',
                                        style: TextStyle(),
                                      ),
                                      // TODO: Request Money
                                      onPressed: () {},
                                    ),
                            ],
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                primary: const Color.fromRGBO(250, 103, 117, 1),
                              ),
                              icon: const Icon(
                                Icons.delete_rounded,
                                size: 20,
                              ),
                              label: const Text(
                                'Withdraw',
                                style: TextStyle(),
                              ),
                              // Withdraw
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
                                              Map<String, dynamic> json = {};
                                              json['waiting-list'] = FieldValue.arrayRemove([user.userid]);
                                              if (isAccepted) {
                                                json['accepted-by'] = '';
                                                json['accepted-by-name'] = '';
                                                json['chat-id'] = '';
                                              }

                                              FirebaseFirestore.instance
                                                  .collection('Posts')
                                                  .doc(postid)
                                                  .set(
                                                    json,
                                                    SetOptions(
                                                      merge: true,
                                                    ),
                                                  )
                                                  .then((value) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.check_rounded,
                                                          color: Colors.green[800],
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Successfully Removed',
                                                          style: TextStyle(
                                                            color: Colors.green[800],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                    backgroundColor: Colors.green[50],
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
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
                                        actionsAlignment: MainAxisAlignment.spaceAround,
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
