import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/dailyTimeSeries.dart';
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/stats_monthly.dart';
import 'package:strollr/statistic/timeSeries.dart';

class MonthlyTimeChart extends StatefulWidget {
  final List<DailyTimeSeries> dailyminutes;

  MonthlyTimeChart(this.dailyminutes);

  MonthlyTimeChartState createState() => MonthlyTimeChartState();
}

class MonthlyTimeChartState extends State<MonthlyTimeChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<DailyTimeSeries, String>> series = [
      charts.Series(
          id: "Minutes",
          data: widget.dailyminutes,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (DailyTimeSeries series, _) => series.day.toString(),
          measureFn: (DailyTimeSeries series, _) => series.minutes)
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 600,
        height: 400,
        padding: EdgeInsets.only(bottom: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: charts.BarChart(
                    series,
                    animate: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
