import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/Tabs/collection.dart';
import 'package:strollr/Tabs/stats.dart';
import 'package:strollr/statistic/kilometerSeries.dart';
import 'package:strollr/statistic/monthlyKilometer_chart.dart';
import 'package:strollr/statistic/stats_monthly.dart';
import 'package:strollr/globals.dart' as globals;
/* 
class Change extends ChangeNotifier {
  void sliderValueChange(int sliderValue) {
    globals.currentSliderValue = sliderValue;
    notifyListeners();
  }
} */

class KilometerChart extends StatefulWidget {
  final List<MonthlyKilometerSeries> kilometer;

  KilometerChart(this.kilometer);

  State<StatefulWidget> createState() => new KilometerChartState();
}

class KilometerChartState extends State<KilometerChart> {
/*   @override
  void setState(VoidCallback fn) {
    
    super.setState(fn);
  } */
  @override
  Widget build(BuildContext context) {
    List<charts.Series<MonthlyKilometerSeries, String>> series = [
      charts.Series(
          id: "Kilometers",
          data: widget.kilometer,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (MonthlyKilometerSeries series, _) => series.month,
          measureFn: (MonthlyKilometerSeries series, _) => series.kilometers)
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
              /*                  Text(
                    "Kilometerübersicht",
                    style: Theme.of(context).textTheme.bodyText1,
                  ), */
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
    final selectedMonth = model.selectedDatum.first.datum;
    globals.month = selectedMonth.month;
    if (selectedMonth.kilometers > 0.0)
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MonthlyStats(selectedMonth.month)));
  }
}

/* class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => SliderState();
} */

/* class SliderState extends State<SliderWidget> {
  Change change = Change();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 10, 10, 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            globals.currentSliderValue.toString(),
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: globals.currentSliderValue.toDouble(),
            min: 2021,
            max: 2024,
            divisions: 3,
            label: globals.currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                change.sliderValueChange(value.toInt());
                //globals.currentSliderValue = value.toInt();
              });
            },
          )
        ],
      ),
    );
  }
} */
