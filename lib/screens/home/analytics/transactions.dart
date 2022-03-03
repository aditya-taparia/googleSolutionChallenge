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
List<bool> fromto = [true, true, false, true];

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
              title: Row(
                children: [
                  Text(
                    fromname[index].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: fromto[index] ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20)),
                    child: fromto[index]
                        ? const Text(
                            "Recieved",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : const Text("sent",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              subtitle: Text(fromtime[index]),
              trailing: fromto[index]
                  ? Text("+" + fromamount[index].toString() + "/-",
                      style: const TextStyle(color: Colors.green, fontSize: 18))
                  : Text("-" + fromamount[index].toString() + "/-",
                      style: const TextStyle(color: Colors.red, fontSize: 18)),
            ),
          );
        });
  }
}
