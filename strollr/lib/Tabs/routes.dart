import 'package:flutter/material.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import 'package:strollr/route_pages/route_details.dart';
import 'package:strollr/style.dart';
import 'package:strollr/route_pages/route_list_card.dart';
import 'package:intl/intl.dart';


class Routes extends StatelessWidget {

  final List<RouteListCard> routeList = [];
  int navigationID = 2;

  Future<bool> buildRouteList() async {
    List<Walk> walks = await DbRouteInterface.getAllWalks();

    walks.forEach((element) {
      double distance = double.parse(element.distanceInKm.toStringAsFixed(2));

      routeList.add(new RouteListCard(element.id as int, element.startedAtTime, "Datum:", element.name, element.durationTime, distance));
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routen", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: buildRouteList(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: routeList.length, //Database length
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              RouteDetails(routeList[index].routeId, navigationID)));
                    },
                    child: buildRouteListCard(context, index),
                  );
                }
            );
          }
          else {
            return Center(
              child: Text('Lege eine neue Route an.', style: TextStyle(fontSize: 20, color: headerGreen)),
            );
          }
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
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      route.routeName,
                      style: new TextStyle(
                          fontSize: 18.0, color: headerGreen),),
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
                      Text("${DateFormat('dd/MM/yyyy').format(route.routeTime).toString()}", textAlign: TextAlign.left,),
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
}
