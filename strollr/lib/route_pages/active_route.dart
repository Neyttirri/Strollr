import 'package:flutter/material.dart';

import '../style.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final StopWatchTimer _stopWatchTimer = StopWatchTimer();
final _isHours = true;

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
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
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
                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 40, 5),
                child: CustomButton(
                    label: 'Pause',
                    onPress: () {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: CustomButton(
                    label: 'Walk beenden',
                    onPress: () {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
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
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
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
            children: [
              overview,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Foto aufnehmen',
        child: Icon(Icons.add_a_photo_outlined),
        backgroundColor: Colors.green,
        //onPressed: () {
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
        // },
      ),
    );
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
