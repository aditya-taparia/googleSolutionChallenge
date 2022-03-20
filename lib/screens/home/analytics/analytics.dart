import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/chart.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/transactions.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../widgets/loading.dart';

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

earnings(List<dynamic> Earnings, List<dynamic> Spendings) {
  num earnings = 0;
  for (int i = 0; i < Earnings.length; i++) {
    earnings = earnings + Earnings[i];
  }
  for (int i = 0; i < Spendings.length; i++) {
    earnings = earnings - Spendings[i];
  }
  return earnings.toString();
}

points(List<dynamic> points) {
  num total = 0;
  for (int i = 0; i < points.length; i++) {
    total = total + points[i];
  }

  return total.toString();
}

class _AnalyticsState extends State<Analytics>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<DocumentSnapshot> doc = FirebaseFirestore.instance
        .collection('Analytics')
        .doc(user!.userid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: doc,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> AnalyticsSnapShot) {
          if (AnalyticsSnapShot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (AnalyticsSnapShot.hasData) {
            print(AnalyticsSnapShot.data!['Earnings']);
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 125,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Net Earnings : " +
                                      earnings(
                                        AnalyticsSnapShot.data!['Earnings'],
                                        AnalyticsSnapShot.data!['Spendings'],
                                      ),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.handshake,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Link points : " +
                                      points(AnalyticsSnapShot
                                          .data!['Linkpoints']),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pinned: true,
                      floating: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        tabs: const <Tab>[
                          Tab(
                            child: Text(
                              'Charts',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'History',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: const <Widget>[
                    Chart(),
                    Transactions(),
                  ],
                ),
              ),
            );
          }
          return const Loading();
        });
  }
}
