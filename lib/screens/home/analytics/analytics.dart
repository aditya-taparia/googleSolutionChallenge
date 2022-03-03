import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/chart.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/transactions.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

List<String> fromname = ["Sagar", "Aditya", "Kowsik", "Jeetesh"];
List<int> fromamount = [1000, 456, 23453, 25423];
List<String> fromtime = [
  "February 13,2022 at 5:30 AM",
  "April 13,2022 at 5:30 PM",
  "December 13,2021 at 5:30 AM",
  "May 23,2000 at 7:30 PM"
];
List<int> done = [1, 0, 0, 1];
List<int> fromto = [1, 1, 0, 1];

earnings(List<int> fromamount, List<int> fromto) {
  int earnings = 0;
  for (int i = 0; i < fromamount.length; i++) {
    if (fromto[i] == 1) {
      earnings += fromamount[i];
    } else {
      earnings -= fromamount[i];
    }
  }
  return earnings.toString();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130.0),
            child: AppBar(
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Earnings : " + earnings(fromamount, fromto),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Donation : ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  const TabBar(
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: [
                        Tab(
                          child: Text(
                            'Chart',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Tab(
                            child: Text(
                          'History',
                          style: TextStyle(fontSize: 20),
                        )),
                      ])
                ],
              ),
            ),
          ),
          body: TabBarView(children: [chart(), transactions()])),
    );
  }
}
