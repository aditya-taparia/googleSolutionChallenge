import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../widgets/loading.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
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

class _ChartState extends State<Chart> with TickerProviderStateMixin {
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
            List<dynamic> arr1 = AnalyticsSnapShot.data!['Earnings'];
            List<dynamic> arr2 = AnalyticsSnapShot.data!['Spendings'];

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: DefaultTabController(
                          initialIndex: 0,
                          length: 3,
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 320,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(66, 103, 178, 1),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TabBar(
                                    labelColor:
                                        const Color.fromRGBO(66, 103, 178, 1),
                                    unselectedLabelColor: Colors.white,
                                    indicator: const BubbleTabIndicator(
                                        tabBarIndicatorSize:
                                            TabBarIndicatorSize.tab,
                                        indicatorHeight: 40,
                                        indicatorColor: Colors.white),
                                    tabs: [
                                      Tab(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text("Line chart",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Tab(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Text("Bar chart",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      )),
                                      Tab(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Text("Pie Chart",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                width: MediaQuery.of(context).size.width,
                                child: TabBarView(children: [
                                  const SplineArea([
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
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 220.0,
                                            child: Bar(
                                                "earnings",
                                                const [
                                                  "2021-01-15",
                                                  "2021-02-15",
                                                  "2021-03-15",
                                                  "2021-04-15",
                                                  "2021-05-15",
                                                  "2021-06-15",
                                                  "2021-07-15",
                                                  "2021-08-15",
                                                  "2021-09-15",
                                                  "2021-10-15",
                                                  "2021-11-15",
                                                  "2021-12-15",
                                                ],
                                                callValue(arr1, arr2),
                                                Colors.amber),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(),
                                ]))
                          ])),
                    ),
                    StatefulBuilder(builder: ((context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                            backgroundColor:
                                                Color.fromRGBO(66, 103, 178, 1),
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
                                  ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.account_balance_wallet),
                                    ),
                                    title: Text("Earnings"),
                                    trailing: Text(
                                        "- ₹${arr1[monthselected == -1 ? getnowmonth() : monthselected]}.00",
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.paid),
                                    ),
                                    title: const Text("Spending"),
                                    trailing: Text(
                                        "- ₹${arr2[monthselected == -1 ? getnowmonth() : monthselected]}.00",
                                        style: const TextStyle(
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
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }))
                  ],
                ),
              ),
            );
          }
          return const Loading();
        });
  }
}

List<double> callValue(List<dynamic> param0, List<dynamic> param1) {
  List<double> net = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  for (int i = 0; i < 12; i++) {
    net[i] = (param0[i] - param1[i]).toDouble();
  }
  return net;
}
