import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'charts/barchart.dart';
import 'charts/linechart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

int monthselected = -1;

int getnowmonth() {
  var formatter = DateFormat('MM');
  var now = DateTime.now();
  return int.parse(formatter.format(now)) - 1;
}

const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

double offset = getnowmonth() != 0 ? 55.0 * (getnowmonth() + 1) : 0;
ScrollController _scrollController =
    ScrollController(initialScrollOffset: offset);

ScrollController _mainscrollController = new ScrollController();

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 280.0,
                child: CupertinoScrollbar(
                  controller: _mainscrollController,
                  isAlwaysShown: true,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    controller: _mainscrollController,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text("Line Chart"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 220.0,
                                child: const SplineArea([
                                  "2019-12-11",
                                  "2020-02-12",
                                  "2021-01-23",
                                  "2022-01-14",
                                ], [
                                  1,
                                  3,
                                  4,
                                  6,
                                ], [
                                  5,
                                  6,
                                  7,
                                  9,
                                ], [
                                  2,
                                  2,
                                  5,
                                  6,
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text("Bar Chart"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 220.0,
                                child: Bar(
                                    "earnings",
                                    [
                                      "2019-12-11",
                                      "2020-02-12",
                                      "2021-01-23",
                                      "2022-01-14",
                                    ],
                                    [1, 2, 3, 4],
                                    Colors.amber),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Monthly Analysis",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(66, 103, 178, 1),
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              color: Colors.black12,
              child: ListView.builder(
                  itemCount: months.length,
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          monthselected = index;
                        });
                      },
                      child: Container(
                        width: 80,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(months[index]),
                            const SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: Color.fromRGBO(66, 103, 178, 1),
                              child: Text(
                                months[index][0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    monthselected != -1
                        ? Text(
                            months[monthselected],
                            style: const TextStyle(fontSize: 18),
                          )
                        : Text(
                            months[getnowmonth()],
                            style: const TextStyle(fontSize: 18),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.account_balance_wallet),
                      ),
                      title: Text("Earnings"),
                      trailing: Text("+ ₹1000.00",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.paid),
                      ),
                      title: Text("Spending"),
                      trailing: Text("- ₹1000.00",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.handshake),
                      ),
                      title: Text("Charity"),
                      trailing: Text("+ ₹1000.00",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
