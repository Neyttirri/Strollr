import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import 'package:strollr/route_pages/active_route.dart';
import '../style.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/maps_test_two.dart';
import '../style.dart';
import 'dbInterface.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController _controller =
    TextEditingController(text: routeName); // Name aus Datenbank
bool _isEnable = false;

class RouteDetails extends StatefulWidget {
  int walkId = 0;
  String routeName = "";
  double distance = 0;
  String duration = "";
  Gpx route = Gpx();
  MapView map = new MapView();

  RouteDetails(int walkId) {
    this.walkId = walkId;
  }

  Future<bool> setDetails(int walkId) async {
    routeName = await DbRouteInterface.getWalkName(walkId: walkId);
    distance = await DbRouteInterface.getWalkDistance(walkId: walkId);
    duration = await DbRouteInterface.getWalkDuration(walkId: walkId);
    route = await DbRouteInterface.getWalkRoute(walkId: walkId);
    map.createPolyLines(route);

    return true;
  }

  _RouteDetailsState createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {
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
                    children: [RouteForm(), buttonRow(context)],
                  ),
                ))));
  }
}

class RouteForm extends StatefulWidget {
  @override
  RouteFormState createState() => RouteFormState();
}

class RouteFormState extends State<RouteForm> {
  //related to WalkID

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // walkID
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                enabled: _isEnable,
                decoration: const InputDecoration(
                    hintText: 'Gib deiner Route einen Namen',
                    labelText: 'Routenname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
          ]),
          SizedBox(
            height: 250,
          ), //insert map
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text("Berlin"),
                Spacer(),
                Text("2020"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text("Strecke in km:"),
                Spacer(),
                Text(distance.toString() + ' km'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text("Zeit in Stunden:"),
                Spacer(),
                Text('2:00 h'), //Text('$duration h')
              ],
            ),
          ),
        ],
      ),
    );
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
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Route wird gespeichert')));
          setState(() {
            _isEnable = false;
          });
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
        children: [deleteButton(context), SaveButton()],
      ));
}
