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

  late double jan;
  late double feb;
  late double mar;
  late double apr;
  late double may;
  late double jun;
  late double jul;
  late double aug;
  late double sep;
  late double oct;
  late double nov;
  late double dec;

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
      jan,
    ),
    MonthlyKilometerSeries(
      "FEB",
      feb,
    ),
    MonthlyKilometerSeries(
      "MRZ",
      mar,
    ),
    MonthlyKilometerSeries(
      "APR",
      apr,
    ),
    MonthlyKilometerSeries(
      "MAI",
      may,
    ),
    MonthlyKilometerSeries(
      "JUN",
      jun,
    ),
    MonthlyKilometerSeries(
      "JUL",
      jul,
    ),
    MonthlyKilometerSeries(
      "AUG",
      aug,
    ),
    MonthlyKilometerSeries(
      "SEP",
      sep,
    ),
    MonthlyKilometerSeries(
      "OKT",
      oct,
    ),
    MonthlyKilometerSeries(
      "NOV",
      nov,
    ),
    MonthlyKilometerSeries(
      "DEZ",
      dec,
    ),
  ];

  late List<MonthlyKilometerSeries> defaultkilometers = [
    MonthlyKilometerSeries(
      "JAN",
      0.0,
    ),
    MonthlyKilometerSeries(
      "FEB",
      0.0,
    ),
    MonthlyKilometerSeries(
      "MRZ",
      0.0,
    ),
    MonthlyKilometerSeries(
      "APR",
      0.0,
    ),
    MonthlyKilometerSeries(
      "MAI",
      0.0,
    ),
    MonthlyKilometerSeries(
      "JUN",
      0.0,
    ),
    MonthlyKilometerSeries(
      "JUL",
      0.0,
    ),
    MonthlyKilometerSeries(
      "AUG",
      0.0,
    ),
    MonthlyKilometerSeries(
      "SEP",
      0.0,
    ),
    MonthlyKilometerSeries(
      "OKT",
      0.0,
    ),
    MonthlyKilometerSeries(
      "NOV",
      0.0,
    ),
    MonthlyKilometerSeries(
      "DEZ",
      0.0,
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
/*   void initState() {
    super.initState();    

  } */

  Future<bool> setKilometers() async {
    YearWithDistances monthly =
        await DbHelper.getAllMonthlyDistancesInYear(widget.year);
    widget.jan = monthly.distancesPerMonth[0];
    widget.feb = monthly.distancesPerMonth[1];
    widget.mar = monthly.distancesPerMonth[2];
    widget.apr = monthly.distancesPerMonth[3];
    widget.may = monthly.distancesPerMonth[4];
    widget.jun = monthly.distancesPerMonth[5];
    widget.jul = monthly.distancesPerMonth[6];
    widget.aug = monthly.distancesPerMonth[7];
    widget.sep = monthly.distancesPerMonth[8];
    widget.oct = monthly.distancesPerMonth[9];
    widget.nov = monthly.distancesPerMonth[10];
    widget.dec = monthly.distancesPerMonth[11];
    print(widget.jul);
    return true;
  }

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
          FutureBuilder(
            future: setKilometers(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return KilometerChart(widget.kilometers);
              } else {
                return KilometerChart(widget.defaultkilometers);
              }
            },
          ),
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
