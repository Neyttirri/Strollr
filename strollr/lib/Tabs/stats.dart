import 'package:flutter/material.dart';
import 'package:strollr/privacy_policy/privacyPolicy.dart';
import '../style.dart';
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/kilometer_chart.dart';
import 'package:strollr/statistic/timeSeries.dart';
import 'package:strollr/statistic/time_chart.dart';
import 'package:strollr/db/database_interface_helper.dart';
import 'package:strollr/globals.dart' as globals;

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

  late double janM;
  late double febM;
  late double marM;
  late double aprM;
  late double mayM;
  late double junM;
  late double julM;
  late double augM;
  late double sepM;
  late double octM;
  late double novM;
  late double decM;

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
      0,
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
  final int ID_PRIVACY_POLICY = 0;

  Future<bool> setminutes() async {
    YearWithDuration monthlyM =
        await DbHelper.readAllWalkDurationMonthlyInAYear(2021);
    for (int i = 0; i < monthlyM.durationPerMonth.length; i++) {
      //('stats: $i : ${monthlyM.durationPerMonth[i]}');
    }

    widget.janM = monthlyM.durationPerMonth[0];
    widget.febM = monthlyM.durationPerMonth[1];
    widget.marM = monthlyM.durationPerMonth[2];
    widget.aprM = monthlyM.durationPerMonth[3];
    widget.mayM = monthlyM.durationPerMonth[4];
    widget.junM = monthlyM.durationPerMonth[5];
    widget.julM = monthlyM.durationPerMonth[6];
    widget.augM = monthlyM.durationPerMonth[7];
    widget.sepM = monthlyM.durationPerMonth[8];
    widget.octM = monthlyM.durationPerMonth[9];
    widget.novM = monthlyM.durationPerMonth[10];
    widget.decM = monthlyM.durationPerMonth[11];

    widget.minutes = [
      TimeSeries(
        "JAN",
        widget.janM,
      ),
      TimeSeries(
        "FEB",
        widget.febM,
      ),
      TimeSeries(
        "MRZ",
        widget.marM,
      ),
      TimeSeries(
        "APR",
        widget.aprM,
      ),
      TimeSeries(
        "MAI",
        widget.mayM,
      ),
      TimeSeries(
        "JUN",
        widget.junM,
      ),
      TimeSeries(
        "JUL",
        widget.julM,
      ),
      TimeSeries(
        "AUG",
        widget.augM,
      ),
      TimeSeries(
        "SEP",
        widget.sepM,
      ),
      TimeSeries(
        "OKT",
        widget.octM,
      ),
      TimeSeries(
        "NOV",
        widget.novM,
      ),
      TimeSeries(
        "DEZ",
        widget.decM,
      ),
    ];
    return true;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken 2021", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: headerGreen,
        ),
        actions: [
          getPrivacyPolicy(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //SliderWidget(),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 2.0),
              child: Text(
                'Kilometerübersicht',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.black),
              ),
            ),
          ),
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
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 2.0),
              child: Text(
                'Zeitübersicht',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.black),
              ),
            ),
          ),
          FutureBuilder(
            future: setminutes(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && widget.minutes.isNotEmpty) {
                return TimeChart(widget.minutes);
              } else {
                return TimeChart(widget.defaultminutes);
              }
            },
          ),
          Summary()
        ]),
      ),
    );
  }

  Widget getPrivacyPolicy(BuildContext context) {
    return PopupMenuButton(
      elevation: 3.2,
      offset: Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      onSelected: (choice) {
        if (choice == ID_PRIVACY_POLICY) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PrivacyPolicy()));
        } else
          print('nothing chosen !!  ');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.privacy_tip_outlined),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text('Datenschutzerklärung'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Summary extends StatefulWidget {
  double distancesAll = 0.0;
  double durationAll = 0.0;
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
    YearWithDuration yearlyM = await DbHelper.readAllWalkDurationMonthlyInAYear(
        globals.currentSliderValue);

    for (int i = 0; i < yearlyM.durationPerMonth.length; i++) {
      widget.durationAll = widget.durationAll + yearlyM.durationPerMonth[i];
    }
    print(widget.durationAll);

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
                        widget.distancesAll.toStringAsFixed(2) + ' km',
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
                        getTimeStringFromDouble(widget.durationAll) + ' h',
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

  String formatStringTime(double durationALl) {
    String duration = durationALl.toStringAsFixed(2);
    String time = duration.replaceAll(".", ':');

    return time;
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue}'.padLeft(2, '0');
  }
}
