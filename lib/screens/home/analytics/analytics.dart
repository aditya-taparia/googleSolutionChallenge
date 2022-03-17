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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 170,
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
                          "Earnings : " + earnings(fromamount, fromto),
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
                      children: const [
                        Icon(
                          Icons.handshake,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Donations : 1000/-",
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
                tabs: <Tab>[
                  Tab(text: 'Charts'),
                  Tab(text: 'History'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Chart(),
            Transactions(),
          ],
        ),
      ),
    );
  }
}
