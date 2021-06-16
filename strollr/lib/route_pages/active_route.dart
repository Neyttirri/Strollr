import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import '../globals.dart' as globals;
import '../style.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../maps_test_two.dart';
import 'dart:math';

final _isHours = true;
final maps = new MapView();

final _trackingInterval = Duration(seconds: 5);
Timer _timer;
bool _paused = false;

double distance = 0;

Geolocator _geolocator = Geolocator();

var gpx = Gpx();

final overview = DefaultTextStyle.merge(
  style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 25),
  child: Container(
    padding: EdgeInsets.fromLTRB(3, 10, 10, 5),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.black),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    StreamBuilder<int>(
                        stream: globals.stopWatchTimer.rawTime,
                        initialData: globals.stopWatchTimer.rawTime.value,
                        builder: (context, snapshot) {
                          final value = snapshot.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value,
                              hours: _isHours);
                          return Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(displayTime));
                        }),
                    Icon(Icons.timer, color: Colors.green[500]),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8), child: Text('0.0 km')),
                      Icon(Icons.directions_walk_outlined,
                          color: Colors.green[500]),
                    ],
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 3, 5),
                child: CustomButton(
                    label: 'Start',
                    onPress: () {
                      _paused = false;

                      globals.stopWatchTimer.onExecute
                          .add(StopWatchExecute.start);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 40, 5),
                child: CustomButton(
                    label: 'Pause',
                    onPress: () {
                      _paused = true;

                      globals.stopWatchTimer.onExecute
                          .add(StopWatchExecute.stop);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: CustomButton(
                    label: 'Walk beenden',
                    onPress: () {
                      _timer.cancel();

                      var gpxString = GpxWriter().asString(gpx, pretty: true);
                      print(gpxString);
                      print('Distance: $distance' + 'km');

                      gpx.wpts.clear();

                      globals.stopWatchTimer.onExecute
                          .add(StopWatchExecute.stop);
                    }),
              ),
            ])
          ],
        ),
      ],
    ),
  ),
);

class ActiveRoute extends StatefulWidget {
  @override
  _ActiveRouteState createState() => _ActiveRouteState();
}

class _ActiveRouteState extends State<ActiveRoute> {
   @override
   void initState() {
     super.initState();
     //initiate periodic Timer on init
     _timer = startTracking();
     gpx.creator = "track";
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aktive Route", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [overview, new Expanded(child: maps)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Foto aufnehmen',
        child: Icon(Icons.add_a_photo_outlined),
        backgroundColor: Colors.grey[500],
        //onPressed: () {
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
        // },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /*
  * gets current Position
  * if Route isn't paused and Position has changed compared to last entry in gpx file
  * new entry is written
  * updates covered distance
   */
   Timer startTracking(){
     return Timer.periodic(_trackingInterval, (timer) async {
       if (_paused) return;

       Position currentPosition = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

       double distanceToLastPosition = 0;

       if (gpx.wpts.isNotEmpty) distanceToLastPosition = calcDistance(gpx.wpts[gpx.wpts.length - 1].lat, currentPosition.latitude,
                                    gpx.wpts[gpx.wpts.length - 1].lon, currentPosition.longitude);

       if (gpx.wpts.isNotEmpty && distanceToLastPosition < 0.2) return;

       double lat1 = gpx.wpts.isEmpty ? currentPosition.latitude : gpx.wpts[gpx.wpts.length - 1].lat;
       double lat2 = currentPosition.latitude;

       double lon1 = gpx.wpts.isEmpty ? currentPosition.longitude : gpx.wpts[gpx.wpts.length - 1].lon;
       double lon2 = currentPosition.longitude;

       distance += calcDistance(lat1, lat2, lon1, lon2);

       writeGpxFile(currentPosition);
     });
   }

  void writeGpxFile(Position current){
     gpx.wpts.add(
       Wpt(lat: current.latitude, lon: current.longitude)
     );
  }

  //calculates distance between two coordinates
  double calcDistance(double lat1, double lat2, double lon1, double lon2) {
    double dToR = 0.017453293; //Degree to radius
    double r = 6371.393; //earth radius

    double rLat1 = lat1 * dToR;
    double rLat2 = lat2 * dToR;
    double rLon1 = lon1 * dToR;
    double rLon2 = lon2 * dToR;

    double distLon = rLon1 - rLon2;
    double distLat = rLat1 - rLat2;

    double a = pow(sin(distLat / 2), 2) + cos(rLat1) * cos(rLat2) *
        pow(sin(distLon / 2), 2); //some weird math hyper brain stuff
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double d = r * c;

    return double.parse((d).toStringAsFixed(2));
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPress;

  CustomButton({this.onPress, this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[500]),
      ),
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
