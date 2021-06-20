import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 6,
          backgroundColor: Colors.green[300],
          valueColor:
          new AlwaysStoppedAnimation<Color>(Colors.green[900]!),
        ),
      ),
    );
  }
}
