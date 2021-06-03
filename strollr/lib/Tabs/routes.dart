import 'package:flutter/material.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/route_pages/new_route.dart';
import 'package:strollr/style.dart';

class Routes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routen", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: <Widget>[
                  Text("Route ${index + 1}"),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Neue Route',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewRoute()));
          //onPressed: () => Navigator.pushNamed(context, 'newRoute')
        },
      ),
    );
  }
}
