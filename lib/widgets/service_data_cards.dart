import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/more_details_page.dart';
import 'package:intl/intl.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 265,
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
                        style: TextStyle(
                          fontSize: 20,
                          color: isAccepted
                              ? const Color.fromRGBO(66, 103, 178, 1)
                              : const Color.fromRGBO(219, 68, 55, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: isAccepted
                            ? Colors.grey[600]
                            : Colors.deepOrange[600],
                      ),
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
                  height: 60,
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                      DateFormat('dd-MM-yyyy')
                          .format(expectedCompletionDate.toDate()),
                      //expectedCompletionDate.toDate().toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Accepted By
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
                isAccepted
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
                                    onPressed: () {},
                                  )
                                : Container(
                                    height: 40,
                                    width: 175,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          const Color.fromRGBO(15, 157, 88, 1),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : Center(
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.orange[400],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.pending_actions_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Pending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
