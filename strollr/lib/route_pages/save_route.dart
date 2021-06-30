import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import 'package:strollr/maps_test_two.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import '../style.dart';
import 'PolylineIf.dart';

final _formKey = GlobalKey<FormState>();

late String nValue;

class RouteSaver extends StatefulWidget {
  _RouteSaverState createState() => _RouteSaverState();
}

class _RouteSaverState extends State<RouteSaver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Routenübersicht',
              style: TextStyle(color: headerGreen)),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => map.createPolyLines(MapRouteInterface.gpx));
  }

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
            decoration: const InputDecoration(
                hintText: 'Gib deiner Route einen Namen',
                labelText: 'Routenname'),
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
              if (snapshot.hasData){
                print(snapshot.data.toString());

                return Row(
                  children: <Widget>[
                    Text("Start am/um:"),
                    Spacer(),
                    Text(started.toString() + ' Uhr'),
                  ],
                );
              }
              else {
                return Row(
                  children: <Widget>[
                    Text("Start am/um:"),
                    Spacer(),
                    Text(''),
                  ],
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: FutureBuilder(
              future: setDistance(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return Row(
                    children: <Widget>[
                      Text("Distanz:"),
                      Spacer(),
                      Text(distance.toString() + 'km'),
                    ],
                  );
                }
                else {
                  return Row(
                    children: <Widget>[
                      Text("Distanz:"),
                      Spacer(),
                      Text(''),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: FutureBuilder(
              future: setDuration(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return Row(
                    children: <Widget>[
                      Text("Dauer:"),
                      Spacer(),
                      Text(duration.toString() + 'h'),
                    ],
                  );
                }
                else {
                  return Row(
                    children: <Widget>[
                      Text("Dauer:"),
                      Spacer(),
                      Text(''),
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
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.green),
    ),
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        await DbRouteInterface.setWalkName(name: nValue);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Route wird gespeichert')));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Routes()));
      }
    },
    child: Text('speichern'),
  );
}

Widget deleteButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    ),
    onPressed: () {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Route wird gelöscht')));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Routes()));
    },
    child: Text(' Route löschen'),
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
