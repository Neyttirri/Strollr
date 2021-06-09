import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  BitmapDescriptor markerIcon;

  final Geolocator _geolocator = Geolocator();
  final Set<Marker> _itemMarkers = {};

  // For storing the current position
  Position _currentPosition;

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  _addMarker(latlong) {
    setState(
      () {
        _itemMarkers.add(
          Marker(
            markerId: MarkerId('$latlong'),
            position: LatLng(
              latlong.latitude,
              latlong.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Start',
            ),
            icon: markerIcon,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getMarkerIcon();
  }

  void changeMapStyle() {
    //add String path as parameter
    getJsonMapStyle("assets/mapsBundle/mapsDefaultView.json").then(setMapStyle);
    //exchange "" with String path parameter just for testing
  }

  Future<String> getJsonMapStyle(String path) {
    return rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  void getMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.0,
      ),
      "assets/images/purple_icon.png",
    ).then(
      (onValue) {
        markerIcon = onValue;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//Determining the screen width & height
    var height = MediaQuery.of(context).size.height * 0.571;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // map itself
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              //mapType: MapType.normal,
              markers: _itemMarkers,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onTap: (latlang) {
                print('${latlang.latitude}, ${latlang.longitude}');
                _addMarker(latlang);
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                changeMapStyle();
              },
            ),
            //Current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.green, // button color
                      child: InkWell(
                        splashColor: Colors.grey, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          _getCurrentLocation();
                          /*
                          * may be redundant
                          * l. 50-54
                           */
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                          /*
                          *
                          *
                           */
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
