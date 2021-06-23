import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeries {
  final String month;
  final int minutes;
  final charts.Color barColor;

  TimeSeries(this.month, this.minutes, this.barColor);
}
