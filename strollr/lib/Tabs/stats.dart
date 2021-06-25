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
      "JAN",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "FEB",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "MRZ",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "APR",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "MAI",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "JUN",
      10,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "JUL",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "AUG",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "SEP",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "OKT",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "NOV",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    KilometerSeries(
      "DEZ",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];

  final List<TimeSeries> minutes = [
    TimeSeries(
      "JAN",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "FEB",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "MRZ",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "APR",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "MAI",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "JUN",
      10,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "JUL",
      5,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "AUG",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "SEP",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "OKT",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "NOV",
      12,
      charts.ColorUtil.fromDartColor(Colors.green),
    ),
    TimeSeries(
      "DEZ",
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
