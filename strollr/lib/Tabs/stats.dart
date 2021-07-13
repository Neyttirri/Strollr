import 'package:flutter/material.dart';
import '../style.dart';
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/kilometer_chart.dart';
import 'package:strollr/statistic/timeSeries.dart';
import 'package:strollr/statistic/time_chart.dart';
import 'package:strollr/db/database_interface_helper.dart';
import 'package:strollr/globals.dart' as globals;
import 'package:provider/provider.dart';

/* DateTime dateToday = DateTime(DateTime.now().year);
String _chosenValue = dateToday.toString(); */

class Stats extends StatefulWidget {
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

  late int janM;
  late int febM;
  late int marM;
  late int aprM;
  late int mayM;
  late int junM;
  late int julM;
  late int augM;
  late int sepM;
  late int octM;
  late int novM;
  late int decM;

  late List<MonthlyKilometerSeries> kilometers = List.empty(growable: true);

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

  late List<TimeSeries> minutes = List.empty(growable: true);

  late List<TimeSeries> defaultminutes = [
    TimeSeries(
      "JAN",
      0,
    ),
    TimeSeries(
      "FEB",
      0,
    ),
    TimeSeries(
      "MRZ",
      0,
    ),
    TimeSeries(
      "APR",
      0,
    ),
    TimeSeries(
      "MAI",
      0,
    ),
    TimeSeries(
      "JUN",
      0,
    ),
    TimeSeries(
      "JUL",
      5,
    ),
    TimeSeries(
      "AUG",
      0,
    ),
    TimeSeries(
      "SEP",
      0,
    ),
    TimeSeries(
      "OKT",
      0,
    ),
    TimeSeries(
      "NOV",
      0,
    ),
    TimeSeries(
      "DEZ",
      0,
    ),
  ];

  StatsState createState() => StatsState();
}

class StatsState extends State<Stats> {
  Future<bool> setKilometers() async {
    YearWithDistances monthly =
        await DbHelper.getAllMonthlyDistancesInYear(globals.currentSliderValue);
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

    widget.kilometers = [
      MonthlyKilometerSeries(
        "JAN",
        widget.jan,
      ),
      MonthlyKilometerSeries(
        "FEB",
        widget.feb,
      ),
      MonthlyKilometerSeries(
        "MRZ",
        widget.mar,
      ),
      MonthlyKilometerSeries(
        "APR",
        widget.apr,
      ),
      MonthlyKilometerSeries(
        "MAI",
        widget.may,
      ),
      MonthlyKilometerSeries(
        "JUN",
        widget.jun,
      ),
      MonthlyKilometerSeries(
        "JUL",
        widget.jul,
      ),
      MonthlyKilometerSeries(
        "AUG",
        widget.aug,
      ),
      MonthlyKilometerSeries(
        "SEP",
        widget.sep,
      ),
      MonthlyKilometerSeries(
        "OKT",
        widget.oct,
      ),
      MonthlyKilometerSeries(
        "NOV",
        widget.nov,
      ),
      MonthlyKilometerSeries(
        "DEZ",
        widget.dec,
      ),
    ];

    return true;
  }

  Future<bool> setminutes() async {
/*     YearWithDistances monthlyM =
        await DbHelper.getAllMonthlyDistancesInYear(globals.currentSliderValue);
    widget.janM = monthlyM.distancesPerMonth[0];
    widget.febM = monthlyM.distancesPerMonth[1];
    widget.marM = monthlyM.distancesPerMonth[2];
    widget.aprM = monthlyM.distancesPerMonth[3];
    widget.mayM = monthlyM.distancesPerMonth[4];
    widget.junM = monthlyM.distancesPerMonth[5];
    widget.julM = monthlyM.distancesPerMonth[6];
    widget.augM = monthlyM.distancesPerMonth[7];
    widget.sepM = monthlyM.distancesPerMonth[8];
    widget.octM = monthlyM.distancesPerMonth[9];
    widget.novM = monthlyM.distancesPerMonth[10];
    widget.decM = monthlyM.distancesPerMonth[11]; */
    widget.janM = 10;
    widget.febM = 10;
    widget.marM = 10;
    widget.aprM = 10;
    widget.mayM = 10;
    widget.junM = 10;
    widget.julM = 10;
    widget.augM = 10;
    widget.sepM = 10;
    widget.octM = 10;
    widget.novM = 10;
    widget.decM = 10;

    widget.minutes = [
      TimeSeries(
        "JAN",
        widget.janM,
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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Change(),
      child: Scaffold(
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
                if (snapshot.hasData && widget.kilometers.isNotEmpty) {
                  return KilometerChart(widget.kilometers);
                } else {
                  return KilometerChart(widget.defaultkilometers);
                }
              },
            ),
            FutureBuilder(
              future: setminutes(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && widget.kilometers.isNotEmpty) {
                  return TimeChart(widget.minutes);
                } else {
                  return TimeChart(widget.defaultminutes);
                }
              },
            ),
            Summary()
          ]),
        ),
      ),
    );
  }
}

class Summary extends StatefulWidget {
  double distancesAll = 0.0;
  late double durationAll;
  SummaryState createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  Future<bool> setKilometersAll() async {
    YearWithDistances yearly =
        await DbHelper.getAllMonthlyDistancesInYear(globals.currentSliderValue);
    for (int i = 0; i < yearly.distancesPerMonth.length; i++) {
      widget.distancesAll = widget.distancesAll + yearly.distancesPerMonth[i];
    }
    return true;
  }

  Future<bool> setDurationAll() async {
    List<YearlyDuration> yearlyDuration =
        await DbHelper.readAllWalkDurationYearly();

/*     for (int i = 0; i < yearlyDuration.length; i++) {
      widget.durationAll = widget.durationAll + yearlyDuration.duration[i];
    } */

    return true;
  }

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
        FutureBuilder(
            future: setKilometersAll(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Row(
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
                        widget.distancesAll.toString() + ' km',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
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
                        "0.0 Km",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
        FutureBuilder(
            future: setDurationAll(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 55,
                        height: 55,
                        child: Icon(Icons.timer, color: Colors.green[500])),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        widget.durationAll.toString() + ' h',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 55,
                        height: 55,
                        child: Icon(Icons.timer, color: Colors.green[500])),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        '0:00 h',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ]),
    );
  }
}
