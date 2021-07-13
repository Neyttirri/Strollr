import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/route_pages/PolylineIf.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import 'package:strollr/route_pages/save_route.dart';
import '../camera/edit_picture.dart';
import '../globals.dart' as globals;
import '../style.dart';
import 'package:strollr/stop_watch_timer.dart';
import '../maps_test_two.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'PolylineIf.dart';

final _isHours = true;

final _trackingInterval = Duration(seconds: 5);
late Timer _timer;

int? walkId;

double distance = 0.0;

Geolocator _geolocator = Geolocator();

var gpx = Gpx();

late MapView maps;

class Overview extends StatefulWidget {
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  CustomButton startPause = CustomButton();

  @override
  void initState() {
    super.initState();

    distance = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 5, 5, 3),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<int>(
                      stream: globals.stopWatchTimer.rawTime,
                      initialData: globals.stopWatchTimer.rawTime.value,
                      builder: (context, snapshot) {
                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(
                            value!,
                            hours: _isHours);
                        return Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(displayTime,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    fontSize: 25)));
                      }),
                  Icon(Icons.timer, color: Colors.green[500]),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(distance.toString() + ' km',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: 25))),
                    Icon(Icons.directions_walk_outlined,
                        color: Colors.green[500]),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: startPause,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      child: Text('Route beenden'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        primary: headerGreen,
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        globals.stopWatchTimer.onExecute
                            .add(StopWatchExecuted.stop);

                        setState(() {
                          startPause.changeLabel();
                        });

                        await finishedWalk();
                        MapRouteInterface.walkFinished = true;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RouteSaver()));
                      }),
                ),
              )
            ],
          ),
        ]),
      ]),
    );
  }
}

void printDbValues() async {
  String name = await DbRouteInterface.getWalkName();
  double distance = await DbRouteInterface.getWalkDistance();
  String duration = await DbRouteInterface.getWalkDuration();

  distance = double.parse((distance).toStringAsFixed(2));

  print('Name: $name');
  print('Distance: $distance km');
  print('Duration: $duration h');
}

Future<bool> finishedWalk() async {
  _timer.cancel();

  if (gpx.wpts.isNotEmpty)
    _ActiveRouteState.writeGpxFile(MapRouteInterface.currentPosition);

  await DbRouteInterface.finishWalk(gpx);
  printDbValues();

  MapRouteInterface.gpx = gpx;

  //MapRouteInterface.walkPaused = true;

  gpx.creator = "new route";

  return true;
}

class ActiveRoute extends StatefulWidget {
  @override
  _ActiveRouteState createState() => _ActiveRouteState();
}

class _ActiveRouteState extends State<ActiveRoute> {
  late File _imageFile;
  late Position _currentPosition;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    maps = MapView();

    MapRouteInterface.walkFinished = true;
    //initiate periodic Timer on init
    _timer = startTracking();
    gpx.creator = "route";
    DbRouteInterface.generateWalk(gpx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: headerGreen),
            onPressed: () {
              Navigator.of(context).pop();
              globals.stopWatchTimer.onExecute.add(StopWatchExecuted.reset);
            }),
        title: Text("Aktive Route", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [Overview(), new Expanded(child: maps)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Foto aufnehmen',
          child: Icon(Icons.add_a_photo_outlined),
          backgroundColor: headerGreen,
          foregroundColor: Colors.white,
          onPressed: () {
            _openCamera();
          }
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
          // },
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void makeRoutePage({required BuildContext context, required Widget pageRef}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
        (Route<dynamic> route) => false);
  }

  Future<void> _openCamera() async {
    var picture = (await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 100,
    ))!;

    Position position = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _imageFile = File(picture.path);
      _currentPosition = position;
    });

    // Navigator.popUntil(context, ModalRoute.withName('main_screen'));
    // TODO figure out the Navigator and the context so the persistent bottom navigation bar is not there anymore
    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.push(
        context,
        // the transition
        MaterialPageRoute(
          builder: (context) => EditPhotoScreen(
            arguments: [
              _imageFile,
              _currentPosition,
            ],
          ),
        ),
      ),
    );
  }

  /*
  * gets current Position
  * if Route isn't paused and Position has changed compared to last entry in gpx file
  * new entry is written
  * updates covered distance
   */

  Timer startTracking() {
    return Timer.periodic(_trackingInterval, (timer) async {
      if (MapRouteInterface.walkPaused) return;

      if (MapRouteInterface.walkFinished &&
          MapRouteInterface.gpx.wpts.isNotEmpty) {
        timer.cancel();
      }

      Position? currentPosition = MapRouteInterface().getPosition();
      print('You are here: $currentPosition');

      double distanceToLastPosition = 0;

      if (gpx.wpts.isNotEmpty) {
        distanceToLastPosition = DbRouteInterface.calcDistance(
            (gpx.wpts[gpx.wpts.length - 1]).lat as double,
            currentPosition!.latitude,
            gpx.wpts[gpx.wpts.length - 1].lon as double,
            currentPosition.longitude);

        setState(() {
          distance += distanceToLastPosition;

          distance = double.parse(distance.toStringAsFixed(2));
        });
      }

      if (gpx.wpts.isNotEmpty && distanceToLastPosition < 0.02) return;

      writeGpxFile(currentPosition!);
    });
  }

  static void writeGpxFile(Position? current) {
    gpx.wpts.add(Wpt(lat: current!.latitude, lon: current.longitude));

    MapRouteInterface.gpx = gpx;
  }
}

class CustomButton extends StatefulWidget {
  final _CustomButtonState button = _CustomButtonState();

  changeLabel() {
    button._changeLabel();
  }

  _CustomButtonState createState() => button;
}

class _CustomButtonState extends State<CustomButton> {
  String label = 'Start';

  _changeLabel() {
    setState(() {
      if (label == "Start")
        label = "Pause";
      else
        label = "Start";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(10),
          primary: Colors.white,
          textStyle: TextStyle(fontSize: 18),
          backgroundColor: headerGreen,
        ),
        onPressed: () {
          if (label == 'Start') {
            maps.letsTrack();

            setState(() {
              label = 'Pause';
              MapRouteInterface.walkPaused = false;

              MapRouteInterface.walkFinished = false;

              globals.stopWatchTimer.onExecute.add(StopWatchExecuted.start);
            });
          } else if (label == 'Pause') {
            setState(() {
              label = 'Weiter';
              MapRouteInterface.walkPaused = true;

              globals.stopWatchTimer.onExecute.add(StopWatchExecuted.stop);
            });
          } else if (label == 'Weiter') {
            setState(() {
              label = 'Pause';
              MapRouteInterface.walkPaused = false;

              MapRouteInterface.walkFinished = false;

              globals.stopWatchTimer.onExecute.add(StopWatchExecuted.start);
            });
          }
        },
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
