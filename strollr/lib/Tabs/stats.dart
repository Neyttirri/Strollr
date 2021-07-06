import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../style.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/kilometer_chart.dart';
import 'package:strollr/statistic/timeSeries.dart';
import 'package:strollr/statistic/time_chart.dart';

/* DateTime dateToday = DateTime(DateTime.now().year);
String _chosenValue = dateToday.toString(); */

class Stats extends StatefulWidget {
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

  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: PageView(children: [
        DropDownYear(),
        KilometerChart(widget.kilometers),
        TimeChart(widget.minutes)
      ]),
    );
  }
}

class DropDownYear extends StatefulWidget {
  _DropDownYearState createState() => _DropDownYearState();
}

class _DropDownYearState extends State<DropDownYear> {
  String dropdownValue = '2021';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      //elevation: 5,
      style: const TextStyle(color: Colors.green, fontSize: 20),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['2021', '2022', '2023', '2024']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownMonth extends StatefulWidget {
  _DropDownMonthState createState() => _DropDownMonthState();
}

class _DropDownMonthState extends State<DropDownYear> {
  String dropdownValue = 'Juli';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 5,
      style: const TextStyle(color: Colors.green, fontSize: 20),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'Januar',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

Widget DropDownMenuRow(BuildContext context) {
  return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [DropDownYear(), DropDownMonth()],
      ));
}
