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
  late String month;
  int year = 2021;

  late List<DailyKilometerSeries> dailykilometers = List.empty(growable: true);

  List<DailyKilometerSeries> defaultdailykilometers = [
    DailyKilometerSeries(1, 0),
    DailyKilometerSeries(2, 0),
    DailyKilometerSeries(3, 0),
    DailyKilometerSeries(4, 0),
    DailyKilometerSeries(5, 0),
    DailyKilometerSeries(6, 0),
    DailyKilometerSeries(7, 0),
    DailyKilometerSeries(8, 0),
    DailyKilometerSeries(9, 0),
    DailyKilometerSeries(10, 0),
    DailyKilometerSeries(11, 0),
    DailyKilometerSeries(12, 0),
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

  MonthlyStats(this.month);

  MonthlyStatsState createState() => MonthlyStatsState();
}

class MonthlyStatsState extends State<MonthlyStats> {
  Future<bool> setKilometers(int month, int year) async {
    MonthWithDistances daily =
        await DbHelper.getAllDailyDistancesInAMonth(month, year);

/*     for (int i = 0; i < daily.distancesPerDay.length; i++) {
      print(daily.distancesPerDay[i]);
    } */

    int day = 1;
    for (int i = 0; i < daily.distancesPerDay.length; i++) {
      widget.dailykilometers
          .add(DailyKilometerSeries(day, daily.distancesPerDay[i]));
      day++;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(monthlyCaption(widget.month, widget.year),
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
            FutureBuilder(
              future: setKilometers(monthToInt(widget.month), widget.year),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && widget.dailykilometers.isNotEmpty) {
                  return MonthlyKilometerChart(widget.dailykilometers);
                } else {
                  return MonthlyKilometerChart(widget.defaultdailykilometers);
                }
              },
            ),
            MonthlyTimeChart(widget.dailyminutes),
            MonthlySummary(),
            Categories()
          ],
        ),
      ),
    );
  }

  String monthlyCaption(String month, int year) {
    String mon = '';
    String caption;
    if (month == 'JAN') {
      mon = 'Januar';
    } else if (month == 'FEB') {
      mon = 'Februar';
    } else if (month == 'MRZ') {
      mon = 'März';
    } else if (month == 'APR') {
      mon = 'April';
    } else if (month == 'MAI') {
      mon = 'Mai';
    } else if (month == 'JUN') {
      mon = 'Juni';
    } else if (month == 'JUL') {
      mon = 'Juli';
    } else if (month == 'AUG') {
      mon = 'August';
    } else if (month == 'SEP') {
      mon = 'September';
    } else if (month == 'OKT') {
      mon = 'Oktober';
    } else if (month == 'NOV') {
      mon = 'November';
    } else if (month == 'DEZ') {
      mon = 'Dezember';
    }
    caption = '$mon $year';
    return caption;
  }

  int monthToInt(String month) {
    int monthInt;
    if (month == 'JAN') {
      monthInt = 1;
    } else if (month == 'FEB') {
      monthInt = 2;
    } else if (month == 'MRZ') {
      monthInt = 3;
    } else if (month == 'APR') {
      monthInt = 4;
    } else if (month == 'MAI') {
      monthInt = 5;
    } else if (month == 'JUN') {
      monthInt = 6;
    } else if (month == 'JUL') {
      monthInt = 7;
    } else if (month == 'AUG') {
      monthInt = 8;
    } else if (month == 'SEP') {
      monthInt = 9;
    } else if (month == 'OKT') {
      monthInt = 10;
    } else if (month == 'NOV') {
      monthInt = 11;
    } else if (month == 'DEZ') {
      monthInt = 12;
    } else {
      monthInt = 1;
    }
    return monthInt;
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
