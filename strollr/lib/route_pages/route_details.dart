import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/maps_test_two.dart';


import '../style.dart';
import 'dbInterface.dart';

class RouteDetails extends StatelessWidget {
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
        body: FutureBuilder(
          future: setDetails(walkId),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData){
              return infoCard(context);
            }
            else return infoCard(context);
          },
        )
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
                Text("Routen Name"),
                Spacer(),
                Text(routeName),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget> [
                Text("Stecke in km:"),
                Spacer(),
                Text(distance.toString() + 'km'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget> [
                Text("Zeit in Stunden:"),
                Spacer(),
                Text('$duration h'),
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