import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strollr/globals.dart';
import 'package:strollr/statistic/dailyKilometerSeries.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/db/database_interface_helper.dart';

import 'monthlyKilometer_chart.dart';

/* DateTime dateToday = DateTime(DateTime.now().year);
String _chosenValue = dateToday.toString(); */

class MonthlyStats extends StatefulWidget {
  late List<DailyKilometerSeries> dailykilometers = [
    DailyKilometerSeries(1, 10),
    DailyKilometerSeries(2, 5),
  ];

  MonthlyStatsState createState() => MonthlyStatsState();
}

class MonthlyStatsState extends State<MonthlyStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("monatliche Statistik", style: TextStyle(color: headerGreen)),
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
            Categories()
          ],
        ),
      ),
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
            padding: const EdgeInsets.only(top: 10.0, left: 20),
            child: Text(
              'Anzahl gesammelter Bilder',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                    color: headerGreen,
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
                    color: headerGreen,
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
                    color: headerGreen,
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
                    color: headerGreen,
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
                    color: headerGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
