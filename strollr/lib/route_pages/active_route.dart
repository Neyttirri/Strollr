import 'package:flutter/material.dart';

class ActiveRoute extends StatelessWidget {
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