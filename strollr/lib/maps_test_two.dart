import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/route_pages/PolylineIf.dart';


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
  late _MapViewState map = new _MapViewState();

  void createPolyLines(Gpx gpx){
    Timer(Duration (seconds: 2), () => map._createPolylines(gpx));
  }

  @override
  _MapViewState createState() => map;
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
   late GoogleMapController mapController;
   late BitmapDescriptor markerIcon;

  final Geolocator _geolocator = Geolocator();
  final Set<Marker> _itemMarkers = {};

  final _locationUpdateIntervall = Duration(seconds: 3);
  static Timer? _timer;


  //lines to be drawn in maps
  Set<Polyline> _polylines = {};
  //recorded locations of user
  List<LatLng> polylineCoordinates = [];

  PolylinePoints? polylinePoints;

  Timer _getCurrentLocation() {
    return Timer.periodic(_locationUpdateIntervall, (timer) async {

      if (MapRouteInterface.walkPaused) return;


      if (MapRouteInterface.walkFinished && MapRouteInterface.gpx.wpts.isNotEmpty) {
        //_createPolylines(MapRouteInterface.gpx);
        _timer?.cancel();
        MapRouteInterface.walkPaused = true;
      }

        //print(PolylineIf.gpx);


      if (mounted && !MapRouteInterface.walkFinished) {
        Position? myPosition = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        setState(() {
          // Store the position in the variable
          MapRouteInterface.currentPosition = myPosition;

          print('CURRENT POS: $myPosition');

          // For moving the camera to current location
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                    myPosition.latitude, myPosition.longitude),
                zoom: 18.0,
              ),
            ),
          );
        });
      }
    });
  }


  /*
  * when finished, method will take list of recorded locations
  * connect them via _polylines.add
   */
  void _createPolylines(Gpx gpx) async {
    gpx.wpts.forEach((element)  {
      polylineCoordinates.add(LatLng(element.lat as double,  element.lon  as double));
    });

    LatLng southWestBound = _getBound(true);
    LatLng northEastBound = _getBound(false);

    print(mounted);

    if (mounted) {
      setState(() {

        var gpxString = GpxWriter().asString(MapRouteInterface.gpx, pretty: true);
        print(gpxString);

        _polylines.add(
            Polyline(
                width: 5,
                polylineId: PolylineId('route'),
                color: Colors.blueAccent,
                points: polylineCoordinates
            )
        );

        mapController.animateCamera(
          /*CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  _currentPosition.latitude, _currentPosition.longitude),
            ),
          ),*/
          CameraUpdate.newLatLngBounds(LatLngBounds(southwest: southWestBound,
              northeast: northEastBound), 50)
        );
      });
    }

    if (gpx == MapRouteInterface.gpx) MapRouteInterface.gpx.wpts.clear();
  }

  /*
  * compares coordinates of recorded Locations
  * to find southwest or northwest most points
   */
  _getBound(bool southWest){
    LatLng res = LatLng(MapRouteInterface.gpx.wpts[0].lat as double, MapRouteInterface.gpx.wpts[0].lon as double);

    double resLat = res.latitude;
    double resLon = res.longitude;
    var elementLat;
    var elementLon;

    MapRouteInterface.gpx.wpts.forEach((element) {
      elementLat = element.lat;
      elementLon = element.lon;
      // TODO what happens when null?
      if(elementLat == null || elementLon == null )
        throw Exception('_MapViewState | Should not happen: latitude is null!');
      if (southWest && elementLat < res.latitude) {
        resLat = elementLat;
        res = LatLng(elementLat, elementLon);
      }

      else if (!southWest && elementLat > res.latitude) {
        resLat = elementLat;
        res = LatLng( elementLat, elementLon);
      }
    });

    MapRouteInterface.gpx.wpts.forEach((element) {
      elementLat = element.lat;
      elementLon = element.lon;
      if(elementLat == null || elementLon == null )
        throw Exception('_MapViewState | Should not happen: longitude is null!');
      if (southWest && elementLon < res.longitude) {
        resLon = elementLon;
        res = LatLng(elementLat, elementLon);
      }
      else if (!southWest && elementLon > res.longitude){
        resLon = elementLon;
        res = LatLng(elementLat, elementLon);
      }
    });

    res = LatLng(resLat, resLon);

    return res;
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

    _timer = _getCurrentLocation();

    polylinePoints = PolylinePoints();
    _polylines = {};
  }

  void dispose() {
    _timer?.cancel();
    _polylines = {};

    super.dispose();
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
              polylines: _polylines,
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
                MapRouteInterface.walkFinished = true;
                mapController = controller;
                changeMapStyle();

                _timer = _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}