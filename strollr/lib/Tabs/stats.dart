import 'package:flutter/material.dart';

import '../style.dart';

class Stats extends StatelessWidget {
  final collectables = Container(
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green[500],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/treeIcon.png', width: 50, height: 50),
              Text(
                '4',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/plantIcon.png', width: 50, height: 50),
              Text(
                '8',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/mushroomIcon.png',
                  width: 50, height: 50),
              Text(
                '0',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/animalFootstepIcon.png',
                  width: 50, height: 50),
              Text(
                '1',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  final stats = DefaultTextStyle.merge(
    style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
        letterSpacing: 0.5,
        fontSize: 30),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(
            color: Colors.green[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Text('2 h')),
              Icon(Icons.timer, color: Colors.green[500]),
            ],
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Text('8 km')),
              Icon(Icons.directions_walk_outlined, color: Colors.green[500]),
            ],
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              stats,
              collectables,
            ],
          ),
        ),
      ),
    );
  }
}
