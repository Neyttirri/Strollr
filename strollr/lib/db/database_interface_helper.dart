import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:strollr/model/picture_categories.dart';
import 'database_manager.dart';
import 'package:gpx/gpx.dart';

class DbHelper {
  // *************************  Statistics - Distance *************************
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

// *************************  Statistics - Duration *************************
  static Future<List<YearlyDuration>> readAllWalkDurationYearly() async {
    List<YearlyDuration> res =
        await DatabaseManager.instance.readAllWalkDurationsYearly();
    return summarizeListYearly(res);
  }

  static Future<YearWithDuration> readAllWalkDurationMonthlyInAYear(
      int year) async {
    List<MonthlyDuration> res =
        await DatabaseManager.instance.readAllWalkDurationsMonthly('$year');
    res = summarizeListMonthly(res);
    YearWithDuration yearDuration = YearWithDuration(year);
    for (MonthlyDuration monthly in res) {
      yearDuration.durationPerMonth[monthly.month - 1] =
          roundNumber(monthly.duration);
    }
    return yearDuration;
  }

  static Future<MonthWithDurations> readAllWalkDurationsDailyInAMonth(
      int month, int year) async {
    List<DailyDuration> daysWithWalks = await DatabaseManager.instance
        .readAllWalkDurationsInAMonth(getMonthStringFromInt(month), '$year');
    daysWithWalks = summarizeListDaily(daysWithWalks);
    // get all days in this month
    int daysInThisMonth = DateUtils.getDaysInMonth(year, month);
    MonthWithDurations monthDur = MonthWithDurations(daysInThisMonth);
    for (DailyDuration daily in daysWithWalks) {
      monthDur.durationsPerDay[daily.day - 1] = roundNumber(daily.duration);
    }
    return monthDur;
  }

  static List<YearlyDuration> summarizeListYearly(List<YearlyDuration> list) {
    List<YearlyDuration> res = List.empty(growable: true);
    if (list.length < 2) return list;
    res.add(list.first);
    int index = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i].year == res[index].year) {
        res[index].duration += list[i].duration;
      } else {
        while (list[i].year - 1 != res[index].year) {
          res.add(YearlyDuration(year: res[index].year + 1, duration: 0.0));
          index++;
        }
        index++;
        res.add(list[i]);
      }
    }
    return res;
  }

  static List<MonthlyDuration> summarizeListMonthly(
      List<MonthlyDuration> list) {
    List<MonthlyDuration> res = List.empty(growable: true);
    if (list.length < 2) return list;
    res.add(list.first);
    int index = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i].month == res[index].month) {
        res[index].duration += list[i].duration;
      } else {
        while (list[i].month - 1 != res[index].month) {
          res.add(MonthlyDuration(month: res[index].month + 1, duration: 0.0));
          index++;
        }
        index++;
        res.add(list[i]);
      }
    }
    return res;
  }

  static List<DailyDuration> summarizeListDaily(List<DailyDuration> list) {
    List<DailyDuration> res = List.empty(growable: true);
    if (list.length < 2) return list;
    res.add(list.first);
    int index = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i].day == res[index].day) {
        res[index].duration += list[i].duration;
      } else {
        while (list[i].day - 1 != res[index].day) {
          res.add(DailyDuration(
              year: res[index].year,
              month: res[index].month,
              day: res[index].day + 1,
              duration: 0.0));
          index++;
        }
        index++;
        res.add(list[i]);
      }
    }
    return res;
  }
}

// *************************  Statistics - Duration *************************
class YearlyDurationField {
  static final String year = 'year';
  static final String duration = 'sum_distances';
}

class YearlyDuration {
  int year;
  double duration;

  YearlyDuration({required this.year, required this.duration});

  static YearlyDuration fromJson(Map<String, Object?> json) => YearlyDuration(
        year: int.parse(json[YearlyDurationField.year] as String),
        duration: roundNumber(getDurationFromString(
            json[YearlyDurationField.duration] as String)),
      );
}

class MonthlyDurationField {
  static final String month = 'month';
  static final String duration = 'sum_distances';
}

class MonthlyDuration {
  int month;
  double duration;

  MonthlyDuration({required this.month, required this.duration});

  static MonthlyDuration fromJson(Map<String, Object?> json) => MonthlyDuration(
        month: int.parse(json[MonthlyDurationField.month] as String),
        duration: roundNumber(getDurationFromString(
            json[MonthlyDurationField.duration] as String)),
      );
}

class YearWithDuration {
  final int year;
  late final List<double> durationPerMonth;

  YearWithDuration(this.year) {
    durationPerMonth = List.filled(12, 0.0);
  }

  double getMonthlyDuration(int pos) {
    double durationOfmonth = durationPerMonth[pos];
    return durationOfmonth;
  }
}

class DailyDurationField {
  static final String year = 'year';
  static final String month = 'month';
  static final String day = 'day';
  static final String duration = 'duration';
}

class DailyDuration {
  int year;
  int month;
  int day;
  double duration;

  DailyDuration(
      {required this.year,
      required this.month,
      required this.day,
      required this.duration});

  static DailyDuration fromJson(Map<String, Object?> json) => DailyDuration(
        year: int.parse(json[DailyDurationField.year] as String),
        month: int.parse(json[DailyDurationField.month] as String),
        day: int.parse(json[DailyDurationField.day] as String),
        duration: roundNumber(
            getDurationFromString(json[DailyDurationField.duration] as String)),
      );
}

class MonthWithDurations {
  final int daysInMonth;
  late final List<double> durationsPerDay;

  MonthWithDurations(this.daysInMonth) {
    durationsPerDay = List.filled(daysInMonth, 0.0);
  }
}

// *************************  Statistics - Distance *************************
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

// translate a String in format "hh:mm:ss" to a double
double getDurationFromString(String duration) {
  List<String> measurements = duration.split(':');
  double hours = double.parse(measurements[0]);
  double minutes = double.parse(measurements[1]);
  double seconds = double.parse(measurements[2]);

  return hours + (minutes / 60) + (seconds / 60 / 60);
}
