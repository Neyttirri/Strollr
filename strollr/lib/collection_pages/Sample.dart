import 'package:flutter/material.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import 'package:strollr/route_pages/route_details.dart';
import 'package:strollr/style.dart';
import 'package:strollr/route_pages/route_list_card.dart';
import 'package:intl/intl.dart';

/*
class Routes extends StatelessWidget {

  final List<RouteListCard> routeList = [];

  Future<bool> buildRouteList() async {
    List<Walk> walks = await DbRouteInterface.getAllWalks();

    walks.forEach((element) {
      routeList.add(new RouteListCard(element.id as int, element.startedAtTime, "Berlin", element.name, element.durationTime, element.distanceInKm));
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
                                RouteDetails(routeList[index].routeId)));
                      },
                      child: buildRouteListCard(context, index),
                    );
                  }
              );
            }

            else {
              return ListView.builder(
                  itemCount: routeList.length, //Database length
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                RouteDetails(37)));
                      },
                      child: buildRouteListCard(context, index),
                    );
                  }
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
                      Text("${DateFormat('dd/MM/yyyy').format(route.routeTime).toString()}", textAlign: TextAlign.left,),
                      Spacer(),
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
*/