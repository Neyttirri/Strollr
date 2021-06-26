import 'package:flutter/material.dart';

class RouteSaver extends StatefulWidget {
  _RouteSaverState createState() => _RouteSaverState();
}

class _RouteSaverState extends State<RouteSaver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Routenübersicht'),
          //backgroundColor: Colors.white,
        ),
        body: Center(
            child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [],
          ),
        )));
  }
}
