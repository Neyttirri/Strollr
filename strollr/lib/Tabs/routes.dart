import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/route_pages/new_route.dart';
import 'package:strollr/route_pages/route_details.dart';
import 'package:strollr/style.dart';
import 'package:strollr/route_pages/route_list_card.dart';
import 'package:intl/intl.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/db/database_manager.dart';


class Routes extends StatelessWidget {

  Future<List<Walk>> allWalks = DatabaseManager.instance.readALlWalks();
  late Walk walk;
  late int walkID;

  final List<RouteListCard> routeList = [
    RouteListCard(DateTime.now(), "Berlin", "Botanischer Garten", 34.43, 6.3),
    RouteListCard(DateTime.now(), "Hamburg", "Hamburg Garten", 24.43, 5.1),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routen", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: routeList.length, //Database length
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteDetails(walkID : walkID)));
              },
              child: buildRouteListCard(context, index),
            );

          }
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Neue Route',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
          //onPressed: () => Navigator.pushNamed(context, 'newRoute')
        },
      ),
    );
  }

  Widget buildRouteListCard(BuildContext context, int index) {
    final route = routeList[index];
    //final walk = allWalks[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(route.routeName, style: new TextStyle(fontSize: 18.0),),
                    Spacer(),
                  ]
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    children: <Widget>[
                      Text(route.routeLocation),
                      Spacer(),
                      Text("${DateFormat('dd/MM/yyyy').format(route.routeTime).toString()}", textAlign: TextAlign.right,),
                    ]
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Text("Länge: " + route.routeDistance.toString() + " km"),
                    Spacer(),
                    Text("Dauer: " + route.routeDuration.toString() + " h"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  /*
  Future<List<Walk>> getAllWalks() async {
    allWalks = DatabaseManager.instance.readALlWalks();

    var jsonData = json.decode(allWalks.body);

    List<walk> walks = [];

    for(var u in jsonData) {
      Walk walk = Walk(u)
    }

  }
  */


}
