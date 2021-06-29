import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/Tabs/stats.dart';
import 'package:strollr/statistic/kilometerSeries.dart';

class KilometerChart extends StatefulWidget {
  final List<KilometerSeries> kilometer;

  KilometerChart(this.kilometer);

  State<StatefulWidget> createState() => new KilometerChartState();
}

class KilometerChartState extends State<KilometerChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<KilometerSeries, String>> series = [
      charts.Series(
          id: "Kilometers",
          data: widget.kilometer,
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
                "Kilometerübersicht",
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
    }
  }
}
