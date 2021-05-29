import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  Collection({Key key}) : super(key: key);

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sammlung", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
      ),
    );
  }
}