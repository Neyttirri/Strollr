import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../style.dart';
import 'active_route.dart';
import 'package:strollr/stop_watch_timer.dart';

class NewRoute extends StatefulWidget {
  @override
  _NewRouteState createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                globals.stopWatchTimer.onExecute.add(StopWatchExecuted.reset);
                globals.stopWatchTimer.onExecute.add(StopWatchExecuted.start);
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
