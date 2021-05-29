import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistik", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
      ),
    );
  }
}