import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/Tabs/chart.dart';

class KilometerChart extends StatelessWidget {
  final List<KilometerSeries> kilometer;

  KilometerChart(this.kilometer);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<KilometerSeries, String>> series = [
      charts.Series(
          id: "Kilometers",
          data: kilometer,
          domainFn: (KilometerSeries series, _) => series.month,
          measureFn: (KilometerSeries series, _) => series.kilometers,
          colorFn: (KilometerSeries series, _) => series.barColor)
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
                "Kilometer im Monat",
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
