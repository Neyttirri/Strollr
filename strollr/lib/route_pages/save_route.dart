import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import '../style.dart';

final _formKey = GlobalKey<FormState>();

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
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
              return null;
            },
          ),
          SizedBox(
            height: 250,
          ), //insert map
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text("Datum:"),
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
                Text("12,42 km"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text("Zeit in Stunden:"),
                Spacer(),
                Text("4:32 h"),
              ],
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
    onPressed: () {
      if (_formKey.currentState!.validate()) {
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
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Route wird gelöscht')));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Routes()));
      }
    },
    child: Text(' Route löschen'),
  );
}

Widget buttonRow(BuildContext context) {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [deleteButton(context), saveButton(context)],
  ));
}
