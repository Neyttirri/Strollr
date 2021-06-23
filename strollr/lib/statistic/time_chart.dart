import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/timeSeries.dart';

class TimeChart extends StatelessWidget {
  final List<TimeSeries> minutes;

  TimeChart(this.minutes);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeries, String>> series = [
      charts.Series(
          id: "Minutes",
          data: minutes,
          domainFn: (TimeSeries series, _) => series.month,
          measureFn: (TimeSeries series, _) => series.minutes,
          colorFn: (TimeSeries series, _) => series.barColor)
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Minuten im Monat",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
