import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/bar_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  static const List<String> xdata = [
    "2012-02-27",
    "2012-02-27",
    "2012-02-27",
    "2012-02-27",
    "2012-02-27",
    "2012-02-27",
  ];
  static const List<double> ydata = [6, 8, 2, 11, 3, 5];
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('data')
        // Bar("monthly Analytics", xdata, ydata, Colors.blueAccent),
        );
  }
}
