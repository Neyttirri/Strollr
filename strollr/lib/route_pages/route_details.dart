import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import 'package:strollr/route_pages/active_route.dart';
import '../style.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/maps_test_two.dart';
import 'dbInterface.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController _controller =
    TextEditingController(text: routeName); // Name aus Datenbank
bool _isEnable = false;
late int walkId;
late String nName;

class RouteDetails extends StatefulWidget {
  late int walkId;

  RouteDetails(int walkId) {
    this.walkId = walkId;

    setTextEditor();
  }

  setTextEditor() async {
    String name = await DbRouteInterface.getWalkName(walkId: walkId);

    _controller = TextEditingController(text: name);
  }

  _RouteDetailsState createState() => _RouteDetailsState(walkId);
}

class _RouteDetailsState extends State<RouteDetails> {
  late int walkId;

  _RouteDetailsState(int walkId){
    this.walkId = walkId;
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [RouteForm(walkId), buttonRow(context)],
                  ),
                ))));
  }
}

class RouteForm extends StatefulWidget {
  late int walkId;

  RouteForm(int walkId){
    this.walkId = walkId;
  }

  @override
  RouteFormState createState() => RouteFormState(walkId);
}

class RouteFormState extends State<RouteForm> {
  //related to WalkID
  late MapView map;

  late String name;
  late String started;
  late double distance;
  late String duration;
  late Gpx route;

  RouteFormState(int id){
    walkId = id;

    setRoute();
  }

  @override
  void initState() {
    super.initState();

    map = new MapView();

    ///creates polylines after widget is built
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => drawDemPolylines());
  }

  drawDemPolylines() async {
    await setRoute();

    var gpxString = GpxWriter().asString(route, pretty: true);
    print(gpxString);

    map.createPolyLines(route);
  }

  setRoute() async {
    route = await DbRouteInterface.getWalkRoute(walkId: walkId);
  }

  ///returns true when each attribute is set
  Future<bool> setName() async {
    name = await DbRouteInterface.getWalkName(walkId: walkId);

    print(name);

    return true;
  }


  Future<bool> setDistance() async {
    distance = await DbRouteInterface.getWalkDistance(walkId: walkId);

    distance = double.parse((distance).toStringAsFixed(2));

    return true;
  }

  Future<bool> setDuration() async {
    duration = await DbRouteInterface.getWalkDuration(walkId: walkId);

    return true;
  }

  Future<bool> setStarted() async {
    started = await DbRouteInterface.getWalkName(walkId: walkId);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // walkID
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: setName(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return nameWidget(context);
                }
                return Row();
              }),
          Row(
            children: [new Expanded(child: map)],
          ), //insert map
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

  Widget nameWidget(BuildContext context){
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: _controller,
          enabled: _isEnable,
          decoration: const InputDecoration(
              hintText: 'Gib deiner Route einen Namen',
              labelText: 'Routenname'),
          validator: (value) {
            nName = value!;

            if (value.isEmpty) {
              return 'Bitte gib einen Routennamen ein';
            }
            return null;
          },
        ),
      ),
      IconButton(
          onPressed: () {
            setState(() {
              _isEnable = true;
            });
          },
          icon: Icon(Icons.edit))
    ]);
  }
}

class SaveButton extends StatefulWidget {
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await DbRouteInterface.setWalkName(walkId: walkId, name: nName);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Route wird gespeichert')));
          setState(() {
            _isEnable = false;
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Routes()));
          // neuen Routennamen in Datenbank übernehmen
        }
      },
      child: Text('speichern'),
    );
  }
}

Widget deleteButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    ),
    onPressed: () async {
      await DbRouteInterface.deleteWalk(walkId: walkId);

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
        children: [deleteButton(context), SaveButton()],
      ));
}
