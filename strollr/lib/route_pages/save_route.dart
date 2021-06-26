import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import '../style.dart';

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
          child: Column(
            children: [RouteForm()],
          ),
        )));
  }
}

class RouteForm extends StatefulWidget {
  @override
  RouteFormState createState() {
    return RouteFormState();
  }
}

class RouteFormState extends State<RouteForm> {
  final _formKey = GlobalKey<FormState>(); //related to WalkID

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Route wird gespeichert')));
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Routes()));
                }
              },
              child: Text('speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
