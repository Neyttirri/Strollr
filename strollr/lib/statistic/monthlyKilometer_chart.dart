import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/Tabs/stats.dart';
import 'package:strollr/statistic/kilometerSeries.dart';
import 'dailyKilometerSeries.dart';

class MonthlyKilometerChart extends StatefulWidget {
  final List<DailyKilometerSeries> dailykilometer;

  MonthlyKilometerChart(this.dailykilometer);

  State<StatefulWidget> createState() => new MonthlyKilometerChartState();
}

class MonthlyKilometerChartState extends State<MonthlyKilometerChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<DailyKilometerSeries, String>> series = [
      charts.Series(
          id: "DailyKilometers",
          data: widget.dailykilometer,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (DailyKilometerSeries series, _) => series.day.toString(),
          measureFn: (DailyKilometerSeries series, _) => series.dailykilometers)
      //colorFn: (KilometerSeries series, _) => series.barColor)
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
