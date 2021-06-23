import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/route_pages/PolylineIf.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import '../camera/edit_picture.dart';
import '../globals.dart' as globals;
import '../style.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../maps_test_two.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'PolylineIf.dart';

const routeName = '/extractArguments';

final _isHours = true;
final maps = new MapView();

final _trackingInterval = Duration(seconds: 5);
late Timer _timer;

int? walkId;

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
                              value!,
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
                          padding: EdgeInsets.all(8), child: Text(distance.toString() + 'km')),
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
                      MapRouteInterface.walkPaused = false;

                      MapRouteInterface.walkFinished = false;

                      globals.stopWatchTimer.onExecute
                          .add(StopWatchExecute.start);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 40, 5),
                child: CustomButton(
                    label: 'Pause',
                    onPress: () {
                      MapRouteInterface.walkPaused = true;

                      globals.stopWatchTimer.onExecute
                          .add(StopWatchExecute.stop);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: CustomButton(
                    label: 'Walk beenden',
                    onPress: () {
                      finishedWalk();

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

void finishedWalk(){
  _timer.cancel();

  if (gpx.wpts.isNotEmpty) _ActiveRouteState.writeGpxFile(MapRouteInterface.currentPosition);

  MapRouteInterface.gpx = gpx;
  MapRouteInterface.walkFinished = true;

  gpx.creator = "new route";
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
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400))!;
    // 400x400 is less than 40kB, imageQuality is also for compressing the image

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

      Position? currentPosition = MapRouteInterface().getPosition();
      print('You are here: $currentPosition');

      double distanceToLastPosition = 0;

      if (gpx.wpts.isNotEmpty)
        distanceToLastPosition = DbRouteInterface.calcDistance(
            (gpx.wpts[gpx.wpts.length - 1]).lat as double,
            currentPosition!.latitude,
            gpx.wpts[gpx.wpts.length - 1].lon as double,
            currentPosition.longitude);

      if (gpx.wpts.isNotEmpty && distanceToLastPosition < 0.05) return;

    writeGpxFile(currentPosition!);
    });
  }

  static void writeGpxFile(Position? current) {
    gpx.wpts.add(Wpt(lat: current!.latitude, lon: current.longitude));
    DbRouteInterface.updateWalkRoute(gpx);
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;

  CustomButton({required this.onPress, required this.label});

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
