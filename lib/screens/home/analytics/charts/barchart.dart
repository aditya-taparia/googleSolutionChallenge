import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

class Bar extends StatefulWidget {
  final String name;
  final Color? color;
  final List<String> xdata;
  final List<double> ydata;
  const Bar(this.name, this.xdata, this.ydata, this.color) : super();

  @override
  _BarState createState() => _BarState(name, xdata, ydata, color);
}

// State class of the spline area chart.
class _BarState extends State<Bar> {
  final String name;
  final Color? color;
  final List<String> xdata;
  final List<double> ydata;
  _BarState(this.name, this.xdata, this.ydata, this.color);

  @override
  Widget build(BuildContext context) {
    return _buildBarChart();
  }

  // Returns the cartesian spline are chart.
  SfCartesianChart _buildBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          interval: xdata.length / 10,
          majorGridLines: const MajorGridLines(width: 0),
          dateFormat: DateFormat('''MMM'''),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.compact(),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getBarSeries(),
      zoomPanBehavior: ZoomPanBehavior(
        // To enable the pinch zooming as true.
        enablePinching: true,
        zoomMode: ZoomMode.xy,
        enablePanning: true,
        enableMouseWheelZooming: true,
      ),
      // tooltipBehavior: TooltipBehavior(enable: true),
      trackballBehavior: TrackballBehavior(
        enable: true,
        markerSettings: const TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible,
          height: 6,
          width: 8,
          borderWidth: 1,
        ),
        hideDelay: 2000,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.center,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipSettings: InteractiveTooltip(canShowMarker: true),
        shouldAlwaysShow: false,
      ),
    );
  }

  // Returns the list of chart series
  // which need to render on the spline area chart.
  List<ColumnSeries<_BarData, DateTime>> _getBarSeries() {
    final List<_BarData> chartData = [];
    for (var i = 0; i < xdata.length; i++) {
      if (name == "Monthly Spending Data") {
        chartData.add(_BarData(DateTime.parse(xdata[i]), ydata[i]));
      } else {
        chartData.add(_BarData(DateTime.parse(xdata[i]), ydata[i]));
      }
    }
    return <ColumnSeries<_BarData, DateTime>>[
      ColumnSeries<_BarData, DateTime>(
        dataSource: chartData,
        color: color!.withOpacity(0.4),
        borderColor: color,
        borderWidth: 2,
        borderRadius: BorderRadius.circular(2),
        yValueMapper: (_BarData data, _) => data.y1,
        xValueMapper: (_BarData data, _) => data.year,
      )
    ];
  }
}

// Private class for storing the spline area chart datapoints.
class _BarData {
  _BarData(this.year, this.y1);
  final DateTime year;
  final double y1;
}
