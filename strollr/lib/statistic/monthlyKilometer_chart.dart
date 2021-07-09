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
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Monatsübersicht Monat",
                style: Theme.of(context).textTheme.bodyText1,
              ),
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
    );
  }
}
