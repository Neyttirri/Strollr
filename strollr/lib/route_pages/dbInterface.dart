import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:intl/intl.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/walk.dart';

import 'PolylineIf.dart';

class DbRouteInterface{
  static late Walk walk;

  static Future<int?> generateWalk(Gpx gpx) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(now);

    print('Your Walk will be saved under follwing name: $formatted');

    walk = Walk(
      name: formatted,
      route: 'gpx',
      distanceInKm: 0.0,
      startedAtTime: now,
      endedAtTime: new DateTime(2021),
      durationTime: DateTime.parse("2021-05-22 01:30:00Z"),
    );

    walk = await DatabaseManager.instance.insertWalk(walk);

    return walk.id;
  }

  static Future<int> updateWalkRoute(Gpx gpx) async {
    String updatedRoute = GpxWriter().asString(gpx, pretty: false);

    Walk updatedWalk = walk.copy();

    updatedWalk.route = updatedRoute;

    Position? currentPosition = MapRouteInterface().getPosition();

    double lat1 = gpx.wpts.isEmpty
        ? currentPosition!.latitude
        : gpx.wpts[gpx.wpts.length - 1].lat as double;
    double lat2 = currentPosition!.latitude;

    double lon1 = gpx.wpts.isEmpty
        ? currentPosition.longitude
        : gpx.wpts[gpx.wpts.length - 1].lon as double;
    double lon2 = currentPosition.longitude;



    updatedWalk.distanceInKm += calcDistance(lat1, lat2, lon1, lon2);


    return await DatabaseManager.instance.updateWalk(updatedWalk);
  }

  //calculates distance between two coordinates
  static double calcDistance(double lat1, double lat2, double lon1, double lon2) {
    double dToR = 0.017453293; //Degree to radius
    double r = 6371.393; //earth radius

    double rLat1 = lat1 * dToR; //convert degree to radius
    double rLat2 = lat2 * dToR;
    double rLon1 = lon1 * dToR;
    double rLon2 = lon2 * dToR;

    double distLon = rLon1 - rLon2;
    double distLat = rLat1 - rLat2;

    double a = pow(sin(distLat / 2), 2) +
        cos(rLat1) *
            cos(rLat2) *
            pow(sin(distLon / 2), 2); //some weird math hyper brain stuff
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double d = r * c;

    return double.parse((d).toStringAsFixed(2));
  }
}