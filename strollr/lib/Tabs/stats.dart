import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strollr/statistic/dailyKilometerSeries.dart';
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
      7,
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

  late List<TimeSeries> minutes = [
    TimeSeries(
      "JAN",
      5,
    ),
    TimeSeries(
      "FEB",
      5,
    ),
    TimeSeries(
      "MRZ",
      5,
    ),
    TimeSeries(
      "APR",
      5,
    ),
    TimeSeries(
      "MAI",
      5,
    ),
    TimeSeries(
      "JUN",
      10,
    ),
    TimeSeries(
      "JUL",
      5,
    ),
    TimeSeries(
      "AUG",
      12,
    ),
    TimeSeries(
      "SEP",
      12,
    ),
    TimeSeries(
      "OKT",
      12,
    ),
    TimeSeries(
      "NOV",
      12,
    ),
    TimeSeries(
      "DEZ",
      12,
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
      body: SingleChildScrollView(
        child: Column(children: [
          SliderWidget(),
          KilometerChart(widget.kilometers),
          TimeChart(widget.minutes),
          Summary()
        ]),
      ),
    );
  }
}

class Summary extends StatefulWidget {
  SummaryState createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      margin: const EdgeInsets.only(
          left: 22.0, right: 22.0, bottom: 20.0, top: 10.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20, bottom: 10.0),
          child: Text(
            'Gesamtübersicht',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: headerGreen),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: 55,
                height: 55,
                child: Icon(Icons.directions_walk_outlined,
                    color: Colors.green[500])),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Km",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: 55,
                height: 55,
                child: Icon(Icons.timer, color: Colors.green[500])),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Zeit",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
