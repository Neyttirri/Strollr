import 'dart:math';

class YearlyDistancesField {
  static final String year = 'year';
  static final String distKm = 'sum_distances';
}

class YearlyDistance {
  final int year;
  final double distance;

  YearlyDistance({required this.year, required this.distance});

  static YearlyDistance fromJson(Map<String, Object?> json) => YearlyDistance(
    year: int.parse(json[YearlyDistancesField.year] as String),
    distance: roundNumber(json[YearlyDistancesField.distKm] as double)
  );
}

class MonthlyDistancesField {
  static final String monthInYear = 'month_in_year';
  static final String distKm = 'sum_distances';
}

class MonthlyDistance {
  final String monthInYear;
  final double distance;

  MonthlyDistance({required this.monthInYear, required this.distance});

  static MonthlyDistance fromJson(Map<String, Object?> json) => MonthlyDistance(
      monthInYear: json[MonthlyDistancesField.monthInYear] as String,
      distance: roundNumber(json[MonthlyDistancesField.distKm] as double)
  );
}

class DailyDistancesField {
  static final String day = 'day';
  static final String distKm = 'sum_distances';
}

class DailyDistance {
  final int day;
  final double distance;

  DailyDistance({required this.day, required this.distance});

  static DailyDistance fromJson(Map<String, Object?> json) => DailyDistance(
      day: int.parse(json[YearlyDistancesField.year] as String),
      distance: roundNumber(json[YearlyDistancesField.distKm] as double)
  );
}

double roundNumber(double val, {int places = 2}){
var mod = pow(10.0, places);
return ((val * mod).round().toDouble() / mod);
}