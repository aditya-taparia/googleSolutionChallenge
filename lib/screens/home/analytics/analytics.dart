import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: const Color.fromRGBO(66, 103, 178, 1),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Earnings   ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Donations  ",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
        ),
        DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color.fromRGBO(66, 103, 178, 1),
                child: const TabBar(
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: [
                      Tab(
                        child: Text(
                          'Charts',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Tab(
                          child: Text(
                        'History',
                        style: TextStyle(fontSize: 20),
                      )),
                    ]),
              ),
              Container(
                height: 300,
                child: TabBarView(children: [
                  Container(
                    child: Center(
                      child: Text('Display Tab 1',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Display Tab 2',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
              )
            ],
          ),
        )
      ],
    );
  }
}
