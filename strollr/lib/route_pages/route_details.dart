import 'package:flutter/material.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/db/database_manager.dart';

import '../style.dart';

class RouteDetails extends StatelessWidget {

  late final int walkID;
  late final Walk selectedWalk;

  RouteDetails({required this.walkID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: headerGreen, //change your color here
          ),
          title: Text("Routen Details", style: TextStyle(color: headerGreen)),
          backgroundColor: Colors.white,
        ),
        body: infoCard(context)
    );
  }

  Widget infoCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/images/treeIcon.png"),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/images/plantIcon.png"),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/images/animalFootstepIcon.png"),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/images/mushroomIcon.png"),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 70,
                height: 20,
                child: Center(
                  child: Text(
                    "Bäume",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 20,
                child: Center(
                  child: Text(
                    "Planzen",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 20,
                child: Center(
                  child: Text(
                    "Tiere",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 70,
                height: 20,
                child: Center(
                  child: Text(
                    "Pilze",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget> [
                Text("Stecke in km:"),
                Spacer(),
                Text("12,42 km"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget> [
                Text("Zeit in Stunden:"),
                Spacer(),
                Text("4:32 h"),
              ],
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Text("Map")
        ],
      ),
    );
  }
}