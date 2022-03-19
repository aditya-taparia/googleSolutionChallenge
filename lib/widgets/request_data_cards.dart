import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDataCard extends StatelessWidget {
  final String title;
  final String description;
  final String requestId;
  final String requestStatus;
  final Timestamp completionDate;
  final double amount;
  const RequestDataCard({
    Key? key,
    required this.title,
    required this.description,
    required this.requestId,
    required this.requestStatus,
    required this.completionDate,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 215,
        child: Card(
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
                      child: const Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(111, 185, 143,
                              1), // Color.fromRGBO(250, 103, 117, 1),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Description
                SizedBox(
                  height: 50,
                  child: Text(
                    'DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription ',
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
                      'Expected Completion Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Accepted By
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Accepted By:',
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
                ), */
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
                      'Promised Amount',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Chat Button And [Mark As Done] Button
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(175, 40),
                        primary: const Color.fromRGBO(111, 185, 143, 1),
                        // const Color.fromRGBO(250, 103, 117, 1),
                      ),
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'More Details',
                        style: TextStyle(),
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
