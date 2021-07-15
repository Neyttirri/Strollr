import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import 'package:strollr/maps_test_two.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import '../globals.dart';
import '../stop_watch_timer.dart';
import '../style.dart';
import 'PolylineIf.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

late String nValue;

class RouteSaver extends StatefulWidget {
  _RouteSaverState createState() => _RouteSaverState();
}

class _RouteSaverState extends State<RouteSaver> {
  @override
  void initState() {
    super.initState();

    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Routenübersicht',
              style: TextStyle(color: headerGreen)),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: headerGreen),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [RouteForm(), buttonRow(context)],
                  ),
                ))));
  }
}

class RouteForm extends StatefulWidget {
  @override
  RouteFormState createState() {
    return RouteFormState();
  }
}

class RouteFormState extends State<RouteForm> {
  //related to WalkID
  late MapView map;
  late String started;
  late double distance;
  late String duration;

  @override
  void initState() {
    super.initState();

    map = new MapView();

    ///creates polylines after widget is built
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => map.createPolyLines(gpx: MapRouteInterface.gpx));
  }

  ///returns true when each attribute is set
  Future<bool> setDistance() async {
    distance = await DbRouteInterface.getWalkDistance();

    distance = double.parse((distance).toStringAsFixed(2));

    return true;
  }

  Future<bool> setDuration() async {
    duration = await DbRouteInterface.getWalkDuration();

    return true;
  }

  Future<bool> setStarted() async {
    started = await DbRouteInterface.getWalkName();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // walkID
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: headerGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Gib deiner Route einen Namen',
              //labelText: 'Routenname'
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte gib einen Routennamen ein';
              }
              nValue = value;

              return null;
            },
          ),
          Row(
            children: [new Expanded(child: map)],
          ),
          //insert map
          FutureBuilder(
            future: setStarted(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.toString());

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Datum:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        started.toString() + ' Uhr',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              } else {
                return Row(
                  children: <Widget>[
                    Text(
                      "Start am/um:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: FutureBuilder(
              future: setDistance(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: <Widget>[
                      Text(
                        "Distanz:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        distance.toString() + ' km',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: <Widget>[
                      Text(
                        "Distanz:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: FutureBuilder(
              future: setDuration(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: <Widget>[
                      Text(
                        "Dauer:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        duration.toString() + ' h',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: <Widget>[
                      Text(
                        "Dauer:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget saveButton(BuildContext context) {
  return SizedBox(
    width: 150,
    child: ElevatedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(10),
        primary: Colors.white,
        textStyle: TextStyle(fontSize: 18),
        backgroundColor: headerGreen,
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          MapRouteInterface.gpx.wpts.clear();

          await DbRouteInterface.setWalkName(name: nValue);

          stopWatchTimer.onExecute.add(StopWatchExecuted.reset);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            'Route wird gespeichert',
            style: TextStyle(fontSize: 20),
          )));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Routes()), (route) => false);
        }
      },
      child: Text('Speichern'),
    ),
  );
}

Widget deleteButton(BuildContext context) {
  return SizedBox(
    width: 150,
    child: ElevatedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(10),
        primary: headerGreen,
        textStyle: TextStyle(fontSize: 18),
        backgroundColor: Colors.white,
      ),
      onPressed: () async {
        await DbRouteInterface.deleteWalk();
        MapRouteInterface.gpx.wpts.clear();

        stopWatchTimer.onExecute.add(StopWatchExecuted.reset);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Route wird gelöscht')));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Routes()), (route) => false);
      },
      child: Text(' Route löschen'),
    ),
  );
}

Widget buttonRow(BuildContext context) {
  return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [deleteButton(context), saveButton(context)],
      ));
}
