import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class transactions extends StatefulWidget {
  const transactions({Key? key}) : super(key: key);

  @override
  State<transactions> createState() => _transactionsState();
}

List<String> fromname = ["Sagar", "Aditya", "Kowsik", "Jeetesh"];
List<int> fromamount = [1000, 456, 23453, 25423];
List<String> fromtime = [
  "February 13,2022 at 5:30 AM",
  "April 13,2022 at 5:30 PM",
  "December 13,2021 at 5:30 AM",
  "May 23,2000 at 7:30 PM"
];
List<bool> fromto = [true, false, false, true];
List<bool> isCharity = [true, false, true, false];

class _transactionsState extends State<transactions> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: fromname.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListTile(
              dense: true,
              tileColor:
                  isCharity[index] ? Colors.blue[50] : Colors.transparent,
              onTap: () {},
              leading: CircleAvatar(
                backgroundColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Text(
                  fromname[index][0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              title: Text(
                fromname[index].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(fromtime[index]),
              trailing: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    fromto[index]
                        ? Text(
                            "+ ₹" + fromamount[index].toString(),
                            style: const TextStyle(
                              color: Color.fromRGBO(15, 157, 88, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            "- ₹" + fromamount[index].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    const SizedBox(height: 5),
                    isCharity[index]
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(66, 103, 178, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Charity",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
