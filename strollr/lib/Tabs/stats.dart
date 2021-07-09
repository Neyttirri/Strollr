import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/kilometer_chart.dart';
import 'package:strollr/statistic/timeSeries.dart';
import 'package:strollr/statistic/time_chart.dart';
import 'package:strollr/db/database_interface_helper.dart';

/* DateTime dateToday = DateTime(DateTime.now().year);
String _chosenValue = dateToday.toString(); */

class Stats extends StatefulWidget {
  int year = 2021;
  late YearWithDistances distances = new YearWithDistances(year);

  Stats() {
    this.year = year;
  }

  getYear() {
    return year;
  }

  setYear(int year) {
    this.year = year;
  }

  late List<MonthlyKilometerSeries> kilometers = [
    MonthlyKilometerSeries(
      "JAN",
      10,
    ),
    MonthlyKilometerSeries(
      "FEB",
      distances.getMonthlyDistance(1),
    ),
    MonthlyKilometerSeries(
      "MRZ",
      distances.getMonthlyDistance(2),
    ),
    MonthlyKilometerSeries(
      "APR",
      distances.getMonthlyDistance(3),
    ),
    MonthlyKilometerSeries(
      "MAI",
      distances.getMonthlyDistance(4),
    ),
    MonthlyKilometerSeries(
      "JUN",
      distances.getMonthlyDistance(5),
    ),
    MonthlyKilometerSeries(
      "JUL",
      distances.getMonthlyDistance(6),
    ),
    MonthlyKilometerSeries(
      "AUG",
      distances.getMonthlyDistance(7),
    ),
    MonthlyKilometerSeries(
      "SEP",
      distances.getMonthlyDistance(8),
    ),
    MonthlyKilometerSeries(
      "OKT",
      distances.getMonthlyDistance(9),
    ),
    MonthlyKilometerSeries(
      "NOV",
      distances.getMonthlyDistance(10),
    ),
    MonthlyKilometerSeries(
      "DEZ",
      distances.getMonthlyDistance(11),
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

  StatsState createState() => StatsState();
}

class StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: PageView(children: [
        Column(children: [
          SliderWidget(),
          new Expanded(child: KilometerChart(widget.kilometers))
        ]),
        Column(children: [
          SliderWidget(),
          new Expanded(child: TimeChart(widget.minutes))
        ]),
      ]),
    );
  }
}
