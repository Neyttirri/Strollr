import 'package:flutter/material.dart';
import 'package:strollr/Tabs/active_route.dart';


class Routes extends StatefulWidget {
  Routes({Key key}) : super(key: key);

 @override
 _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routen", style: TextStyle(color: Colors.green)),
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
        //onPressed: () => Navigator.pushNamed(context, 'newRoute')
        },
      ),
    );
  }
}