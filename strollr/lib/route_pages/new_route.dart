import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../style.dart';
import 'active_route.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class NewRoute extends StatefulWidget {
  @override
  _NewRouteState createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neue Route starten", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ActiveRoute()));
                globals.stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                globals.stopWatchTimer.onExecute.add(StopWatchExecute.start);
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                "Route Starten",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        tooltip: 'Foto aufnehmen',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
        },
      ),*/
    );
  }
}
