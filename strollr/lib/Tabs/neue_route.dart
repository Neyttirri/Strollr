import 'package:flutter/material.dart';

class NewRoute extends StatefulWidget {
  NewRoute({Key key}) : super(key: key);

  @override
  _NewRouteState createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aktive Route", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Akive Route")
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Foto aufnehmen',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //onPressed: () {
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
       // },
      ),
    );
  }
}