import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/stats_monthly.dart';
import 'package:strollr/statistic/timeSeries.dart';

class TimeChart extends StatefulWidget {
  final List<TimeSeries> minutes;

  TimeChart(this.minutes);

  TimeChartState createState() => TimeChartState();
}

class TimeChartState extends State<TimeChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeries, String>> series = [
      charts.Series(
          id: "Minutes",
          data: widget.minutes,
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
                "Zeitübersicht",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  selectionModels: [
                    charts.SelectionModelConfig(
                      type: charts.SelectionModelType.info,
                      changedListener: _onSelectionChanged,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(charts.SelectionModel<String> model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isNotEmpty) {
      print("hello");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MonthlyStats()));
    }
  }
}
