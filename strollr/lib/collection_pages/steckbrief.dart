import 'package:flutter/material.dart';

import '../style.dart';

class Steckbrief extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Steckbrief", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Steckbrief")
          ],
        ),
      ),
    );
  }
}