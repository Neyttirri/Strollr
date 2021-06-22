import 'package:flutter/material.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/Tabs/chart.dart';
import 'package:strollr/Tabs/kilometer_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(child: KilometerChart(kilometers)),
    );
  }
}
