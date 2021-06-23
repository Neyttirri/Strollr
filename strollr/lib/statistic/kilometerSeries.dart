import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class KilometerSeries {
  final String month;
  final int kilometers;
  final charts.Color barColor;

  KilometerSeries(this.month, this.kilometers, this.barColor);
}
