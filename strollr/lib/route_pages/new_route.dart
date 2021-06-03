import 'package:flutter/material.dart';

class NewRoute extends StatelessWidget {
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
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewRoute()));
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                "Route Starten",
                style: TextStyle(color: Colors.white),

              ),
            )
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        tooltip: 'Foto aufnehmen',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActiveRoute()));
        },
      ),*/
    );
  }
}