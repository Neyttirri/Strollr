import 'package:flutter/material.dart';

void main() => runApp(RenameMeLater());

class RenameMeLater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.black26,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Strollr'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          constraints: BoxConstraints.loose(
            // expand -> it as much as you can as long as the height stays said height (in double)
            // loose -> does not exceed said size
              Size(400.0,600.0)
          ),
          child: Image.asset(
            'assets/images/startScreen.jpg',
            fit: BoxFit.cover,  // how it is placed in the container ; cover -> fills as much as it can in the container
          ),
        ),
      ),
    );
  }
}
