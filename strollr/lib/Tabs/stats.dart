import 'package:flutter/material.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/kilometer_chart.dart';
import 'package:strollr/statistic/timeSeries.dart';
import 'package:strollr/statistic/time_chart.dart';

class Stats extends StatelessWidget {
  final List<KilometerSeries> kilometers = [
    KilometerSeries(
      "Mai",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "Juni",
      10,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "Juli",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "August",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];

  final List<TimeSeries> minutes = [
    TimeSeries(
      "Mai",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "Juni",
      10,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "Juli",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "August",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body:
          PageView(children: [KilometerChart(kilometers), TimeChart(minutes)]),
    );
  }
}
