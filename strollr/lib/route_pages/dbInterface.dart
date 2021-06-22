import 'package:gpx/gpx.dart';
import 'package:intl/intl.dart';
import 'package:strollr/model/walk.dart';

class DbInterface{
  static late int walk;

  static int? generateWalk(Gpx gpx){
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(now);

    print('Your Walk will be saved under follwing name: $formatted');

    Walk walk = Walk(
      name: formatted,
      route: 'gpx',
      distanceInKm: 0.0,
      startedAtTime: now,
      endedAtTime: new DateTime(2021),
      durationTime: DateTime.parse("2021-05-22 01:30:00Z"),
    );

    return walk.id;
  }

  static void updateWalk(){}
}