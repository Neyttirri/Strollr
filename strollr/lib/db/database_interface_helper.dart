import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:strollr/model/picture_categories.dart';
import 'database_manager.dart';
import 'package:gpx/gpx.dart';

class DbHelper {
  /// the list with distances starts from 0 !
  /// so to get the accurate day you should add 1 to the index
  /// example: the distances for day 11 would be the value at index 10
  static Future<MonthWithDistances> getAllDailyDistancesInAMonth(
      int month, int year) async {
    List<DailyDistance> daysWithWalks = await DatabaseManager.instance
        .readAllWalkDistancesInAMonth(getMonthStringFromInt(month), '$year');
    // get all days in this month
    int daysInThisMonth = DateUtils.getDaysInMonth(year, month);
    MonthWithDistances monthDist = MonthWithDistances(daysInThisMonth);
    for (DailyDistance daily in daysWithWalks) {
      monthDist.distancesPerDay[daily.day - 1] = daily.distance;
    }
    return monthDist;
  }

  static Future<YearWithDistances> getAllMonthlyDistancesInYear(
      int year) async {
    List<MonthlyDistance> monthsWithWalks =
        await DatabaseManager.instance.readAllWalkDistancesMonthly('$year');
    YearWithDistances yearDist = YearWithDistances(year);
    for (MonthlyDistance monthly in monthsWithWalks) {
      yearDist.distancesPerMonth[monthly.monthInYear - 1] = monthly.distance;
    }
    return yearDist;
  }

  static Future<List<YearlyDistance>> readAllWalkDistancesYearly() async {
    return await DatabaseManager.instance.readAllWalkDistancesYearly();
  }

  static int getMonthOrDayFromString(String date) {
    int monthOrDay = 0;
    if (date[0] == '0')
      monthOrDay = int.parse(date[1]);
    else
      monthOrDay = int.parse(date);
    return monthOrDay;
  }

  static String getMonthStringFromInt(int month) {
    if (month < 10)
      return '0$month';
    else
      return '$month';
  }
}

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
      distance: roundNumber(json[YearlyDistancesField.distKm] as double));
}

class MonthlyDistancesField {
  static final String monthInYear = 'month_in_year';
  static final String distKm = 'sum_distances';
}

class MonthlyDistance {
  final int monthInYear;
  final double distance;

  MonthlyDistance({required this.monthInYear, required this.distance});

  static MonthlyDistance fromJson(Map<String, Object?> json) => MonthlyDistance(
      monthInYear: DbHelper.getMonthOrDayFromString(
          json[MonthlyDistancesField.monthInYear] as String),
      distance: roundNumber(json[MonthlyDistancesField.distKm] as double));
}

class DailyDistancesField {
  static final String day = 'day';
  static final String month = 'month';
  static final String year = 'year';
  static final String distKm = 'sum_distances';
}

class DailyDistance {
  final int day;
  final int month;
  final int year;
  final double distance;

  DailyDistance(
      {required this.day,
      required this.month,
      required this.year,
      required this.distance});

  static DailyDistance fromJson(Map<String, Object?> json) => DailyDistance(
      day: DbHelper.getMonthOrDayFromString(
          json[DailyDistancesField.day] as String),
      month: DbHelper.getMonthOrDayFromString(
          json[DailyDistancesField.month] as String),
      year: int.parse(json[DailyDistancesField.year] as String),
      distance: roundNumber(json[DailyDistancesField.distKm] as double));
}

class MonthWithDistances {
  final int daysInMonth;
  late final List<double> distancesPerDay;

  MonthWithDistances(this.daysInMonth) {
    distancesPerDay = List.filled(daysInMonth, 0.0);
  }
}

class YearWithDistances {
  final int year;
  late final List<double> distancesPerMonth;

  YearWithDistances(this.year) {
    distancesPerMonth = List.filled(12, 0.0);
  }

  double getMonthlyDistance(int pos) {
    double distanceOfmonth = distancesPerMonth[pos];
    print('$pos : ${distanceOfmonth.toString()}');
    return distanceOfmonth;
  }
}

class Pin {
  final Categories category;
  final Gpx location;
  final Uint8List image;

  Pin({required this.category, required this.location, required this.image});
}

double roundNumber(double val, {int places = 2}) {
  var mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
