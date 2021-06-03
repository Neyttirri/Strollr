import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
void main() => runApp(maps_test_two());

class maps_test_two extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<maps_test_two> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.899910, 41.129211); //Batman

  void _onMapCreated(GoogleMapController controller) {
    changeMapStyle();
    mapController = controller;
  }

  void changeMapStyle() {    //add String path as parameter
      getJsonMapStyle("assets/mapsBundle/mapsDefaultView.json").then(setMapStyle);
      //exchange "" with String path parameter just for testing
  }

  Future<String> getJsonMapStyle(String path) {
    return rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
