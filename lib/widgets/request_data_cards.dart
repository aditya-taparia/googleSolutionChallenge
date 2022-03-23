import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/more_details_page.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/request_form.dart';
import 'package:intl/intl.dart';

// TODO: Edit Request Page

class RequestDataCard extends StatelessWidget {
  final String title;
  final String acceptedBy;
  final String acceptedByName;
  final String chatId;
  final String completionStatus;
  final String paymentStatus;
  final int waitingCount;
  final String description;
  final String requestId;
  final String requestStatus;
  final Timestamp completionDate;
  final String postType;
  final double amount;
  final String postId;
  const RequestDataCard({
    Key? key,
    required this.title,
    required this.waitingCount,
    required this.description,
    required this.requestId,
    required this.requestStatus,
    required this.completionDate,
    required this.amount,
    required this.acceptedBy,
    required this.acceptedByName,
    required this.chatId,
    required this.completionStatus,
    required this.paymentStatus,
    required this.postType,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
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
                      color: Color.fromRGBO(111, 185, 143, 1),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Description
            SizedBox(
              height: 45,
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
            const SizedBox(height: 5),

            // Chips
            Wrap(
              spacing: 5,
              runSpacing: 0,
              children: [
                // Post Type Chip
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

                // Accepted or Not Chip
                (acceptedBy == '')
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
                (completionStatus == 'ongoing' && acceptedBy != '')
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
                (DateTime.now().compareTo(DateTime.parse(
                                    completionDate.toDate().toString())) >
                                0 &&
                            completionStatus == 'ongoing') &&
                        acceptedBy != ''
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
                (completionStatus == 'completed' && acceptedBy != '')
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
                (completionStatus == 'completed' &&
                        paymentStatus == 'pending' &&
                        acceptedBy != '')
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

            // Waiting List Count
            acceptedBy == ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        waitingCount == 0
                            ? ''
                            : waitingCount == 1
                                ? '$waitingCount person'
                                : '$waitingCount people',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        waitingCount == 0
                            ? 'No one in the waiting list'
                            : ' waiting for response',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 5),

            // Expected Completion Date
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Completion Date:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat('dd-MM-yyyy').format(completionDate.toDate()),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 20,
                    ),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      primary: const Color.fromRGBO(111, 185, 143, 1),
                      onSurface: Colors.grey[600],
                    ),
                    onPressed: completionStatus == 'ongoing'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: ((context) {
                                return RequestForm(
                                  isEditRequest: true,
                                  amount: amount,
                                  date: completionDate,
                                  description: description,
                                  postType: postType,
                                  title: title,
                                  postId: postId,
                                );
                              })),
                            );
                          }
                        : null,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(111, 185, 143, 1),
                    ),
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                    ),
                    label: const Text(
                      'More Details',
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoreDetailsPage(
                            postid: requestId,
                            isRequest: true,
                            title: 'Request Details',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
