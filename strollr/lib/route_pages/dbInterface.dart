import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:intl/intl.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/utils/shared_prefs.dart';

class DbRouteInterface{

  static Future<int?> generateWalk(Gpx gpx) async {
    //TODO insert shared prefs

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(now);
    final String route = GpxWriter().asString(gpx, pretty: false);

    print('Your Walk will be saved under follwing name: $formatted');

    Walk walk = Walk(
      name: formatted,
      route: route,
      distanceInKm: 0.0,
      startedAtTime: now,
      endedAtTime: new DateTime(2021),
      durationTime: '01:30:00',
    );

    walk = await DatabaseManager.instance.insertWalk(walk);

    SharedPrefs.setCurrentWalkId(walk.id as int);

    return walk.id;
  }

  static setWalkName({int walkId = -1, required String name}) async {
    if (walkId == -1) walkId = await SharedPrefs.getCurrentWalkId();

    Walk updatedWalk = await DatabaseManager.instance.readWalkFromId(walkId);

    updatedWalk.name = name;

    await DatabaseManager.instance.updateWalk(updatedWalk);
  }

  static getAllWalks(){
    return DatabaseManager.instance.readALlWalks();
  }

  static Future<int> finishWalk(Gpx gpx) async {
    String updatedRoute = GpxWriter().asString(gpx, pretty: false);

    Walk updatedWalk = await DatabaseManager.instance.readWalkFromId(SharedPrefs.getCurrentWalkId());

    updatedWalk.route = updatedRoute;

    double totalDistance = 0;

    if (gpx.wpts.length > 1){
      for (int i = 1; i < gpx.wpts.length; i++){

        double lat1 =gpx.wpts[i - 1].lat as double;
        double lat2 = gpx.wpts[i].lat as double;

        double lon1 =  gpx.wpts[i - 1].lon as double;
        double lon2 = gpx.wpts[i].lon as double;

        totalDistance += calcDistance(lat1, lat2, lon1, lon2);
      }
    }



    updatedWalk.distanceInKm = totalDistance;

    updatedWalk.endedAtTime = DateTime.now();

    Duration walkDuration = updatedWalk.endedAtTime.difference(updatedWalk.startedAtTime);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(walkDuration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(walkDuration.inSeconds.remainder(60));

    updatedWalk.durationTime = "${twoDigits(walkDuration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

    return await DatabaseManager.instance.updateWalk(updatedWalk);
  }

  static getWalkName({int walkId = -1}) async {
    if (walkId == -1) walkId = await SharedPrefs.getCurrentWalkId();

    Walk getWalk = await DatabaseManager.instance.readWalkFromId(walkId);

    return getWalk.name;
  }

  static Future<double> getWalkDistance({int walkId = -1}) async {
    if (walkId == -1) walkId = SharedPrefs.getCurrentWalkId();

    Walk getWalk = await DatabaseManager.instance.readWalkFromId(walkId);

    return getWalk.distanceInKm;
  }

  static getWalkDuration({int walkId = -1}) async {
    if (walkId == -1) walkId = SharedPrefs.getCurrentWalkId();

    Walk getWalk = await DatabaseManager.instance.readWalkFromId(walkId);

    return getWalk.durationTime;
  }

  static getWalkRoute({int walkId = -1}) async {
    if (walkId == -1) walkId = SharedPrefs.getCurrentWalkId();

    Walk getWalk = await DatabaseManager.instance.readWalkFromId(walkId);

    Gpx resGpx = GpxReader().fromString(getWalk.route);

    return resGpx;
  }

  static deleteWalk({int walkId = -1}) async {
    if (walkId == -1) walkId = SharedPrefs.getCurrentWalkId();

    await DatabaseManager.instance.deleteWalk(walkId);
  }

  static getMarkerPositions({int walkId = -1}) async {
    if (walkId == -1) walkId = await SharedPrefs.getCurrentWalkId();

    List<Picture> picturesOfWalk = await DatabaseManager.instance.readALlPicturesFromWalk(walkId);

    List<LatLng> markerPositions = new List.empty(growable: true);
    
    for (Picture pic in picturesOfWalk){
      Gpx position = GpxReader().fromString(pic.location);

      markerPositions.add(LatLng(position.wpts[0].lat as double, position.wpts[0].lon as double));
    }

    return markerPositions;
  }

  static getPicuturesOfWalk({int walkId = -1}) async {
    if (walkId == -1) walkId = await SharedPrefs.getCurrentWalkId();

    List<Picture> pics = await DatabaseManager.instance.readALlPicturesFromWalk(walkId);

    return pics;
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