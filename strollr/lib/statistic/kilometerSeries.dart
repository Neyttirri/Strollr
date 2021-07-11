import 'package:charts_flutter/flutter.dart' as charts;
import 'package:strollr/db/database_interface_helper.dart';

class MonthlyKilometerSeries {
  final String month;
  final double kilometers;

  MonthlyKilometerSeries(this.month, this.kilometers);
}
