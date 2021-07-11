import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strollr/globals.dart';
import 'package:strollr/statistic/dailyKilometerSeries.dart';
import 'package:strollr/statistic/dailyTimeSeries.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/db/database_interface_helper.dart';

import 'monthlyKilometer_chart.dart';
import 'monthlyTime_chart.dart';

/* DateTime dateToday = DateTime(DateTime.now().year);
String _chosenValue = dateToday.toString(); */

class MonthlyStats extends StatefulWidget {
  late List<DailyKilometerSeries> dailykilometers = [
    DailyKilometerSeries(1, 10),
    DailyKilometerSeries(2, 5),
    DailyKilometerSeries(3, 5),
    DailyKilometerSeries(4, 5),
    DailyKilometerSeries(5, 5),
    DailyKilometerSeries(6, 5),
    DailyKilometerSeries(7, 5),
    DailyKilometerSeries(8, 5),
    DailyKilometerSeries(9, 5),
    DailyKilometerSeries(10, 5),
    DailyKilometerSeries(11, 5),
    DailyKilometerSeries(12, 5),
    DailyKilometerSeries(13, 5),
    DailyKilometerSeries(14, 5),
    DailyKilometerSeries(15, 5),
    DailyKilometerSeries(16, 5),
    DailyKilometerSeries(17, 5),
    DailyKilometerSeries(18, 5),
    DailyKilometerSeries(19, 5),
  ];

  late List<DailyTimeSeries> dailyminutes = [
    DailyTimeSeries(1, 20),
    DailyTimeSeries(2, 20),
    DailyTimeSeries(3, 20),
    DailyTimeSeries(4, 2),
    DailyTimeSeries(5, 5),
    DailyTimeSeries(6, 20),
    DailyTimeSeries(7, 10),
    DailyTimeSeries(8, 8),
    DailyTimeSeries(9, 20),
    DailyTimeSeries(10, 20),
    DailyTimeSeries(11, 20),
    DailyTimeSeries(12, 20),
    DailyTimeSeries(13, 20),
    DailyTimeSeries(14, 20),
  ];

  MonthlyStatsState createState() => MonthlyStatsState();
}

class MonthlyStatsState extends State<MonthlyStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("monatliche Statistik  + Monat",
            style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: headerGreen),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MonthlyKilometerChart(widget.dailykilometers),
            MonthlyTimeChart(widget.dailyminutes),
            MonthlySummary(),
            Categories()
          ],
        ),
      ),
    );
  }
}

class MonthlySummary extends StatefulWidget {
  MonthlySummaryState createState() => MonthlySummaryState();
}

class MonthlySummaryState extends State<MonthlySummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      margin: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 20.0),
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

class Categories extends StatefulWidget {
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFBDBDBD)),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        margin: const EdgeInsets.only(left: 22.0, right: 22.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, bottom: 20.0),
            child: Text(
              'Anzahl gesammelter Bilder',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: headerGreen),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 55,
                height: 55,
                child: Image.asset(treeImagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Anzahl",
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
                child: Image.asset(plantImagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Anzahl",
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
                width: 50,
                height: 50,
                child: Image.asset(animalImagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Anzahl",
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
                width: 50,
                height: 50,
                child: Image.asset(mushroomImagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Anzahl",
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
                width: 50,
                height: 50,
                child: Image.asset(undefinedCategoryImagePath),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Anzahl",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}