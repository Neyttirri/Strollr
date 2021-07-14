import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/route_pages/PolylineIf.dart';
import 'package:strollr/route_pages/dbInterface.dart';
import 'package:strollr/style.dart';
import 'package:strollr/utils/shared_prefs.dart';

import 'collection_pages/steckbrief_secondVersion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapView();
  }
}

class MapView extends StatefulWidget {
  late _MapViewState map = new _MapViewState();

  void letsTrack() {
    map.activateTracker();
  }

  void createPolyLines({required Gpx gpx, int walkId = -1}) async {
    if (walkId == -1) walkId = await SharedPrefs.getCurrentWalkId();

    Timer(Duration(seconds: 2), () => map._createPolylines(gpx));
    Timer(Duration(seconds: 2), () => map._setMarkers(walkId));
  }

  @override
  _MapViewState createState() => map;
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  late List<BitmapDescriptor> _markerIcons;
  final Set<Marker> _itemMarkers = {};

  late int navigationID = 2;

  late List<Picture> pics;

  final Geolocator _geolocator = Geolocator();

  //lines to be drawn in maps
  Set<Polyline> _polylines = {};
  //recorded locations of user
  List<LatLng> polylineCoordinates = [];

  PolylinePoints? polylinePoints;

  void activateTracker() async {
    StreamSubscription<Position> positionStream = await _geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.high, distanceFilter: 20))
        .listen((event) {
      if (MapRouteInterface.walkPaused || MapRouteInterface.walkFinished)
        return;

      MapRouteInterface.currentPosition = event;

      if (mounted) {
        setState(() {
          // For moving the camera to current location
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(event.latitude, event.longitude),
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
    gpx.wpts.forEach((element) {
      polylineCoordinates
          .add(LatLng(element.lat as double, element.lon as double));
    });

    LatLng southWestBound = _getBound(true, gpx);
    LatLng northEastBound = _getBound(false, gpx);

    if (mounted) {
      setState(() {
        var gpxString = GpxWriter().asString(gpx, pretty: true);
        print(gpxString);

        _polylines.add(Polyline(
            width: 5,
            polylineId: PolylineId('route'),
            color: headerGreen,
            points: polylineCoordinates));

        mapController.animateCamera(
            /*CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  _currentPosition.latitude, _currentPosition.longitude),
            ),
          ),*/
            CameraUpdate.newLatLngBounds(
                LatLngBounds(
                    southwest: southWestBound, northeast: northEastBound),
                50));
      });
    }
  }

  /*
  * compares coordinates of recorded Locations
  * to find southwest or northwest most points
   */
  _getBound(bool southWest, Gpx gpx) {
    LatLng res = LatLng(gpx.wpts[0].lat as double, gpx.wpts[0].lon as double);

    double resLat = res.latitude;
    double resLon = res.longitude;
    var elementLat;
    var elementLon;

    gpx.wpts.forEach((element) {
      elementLat = element.lat;
      elementLon = element.lon;
      // TODO what happens when null?
      if (elementLat == null || elementLon == null)
        throw Exception('_MapViewState | Should not happen: latitude is null!');
      if (southWest && elementLat < res.latitude) {
        resLat = elementLat;
        res = LatLng(elementLat, elementLon);
      } else if (!southWest && elementLat > res.latitude) {
        resLat = elementLat;
        res = LatLng(elementLat, elementLon);
      }
    });

    gpx.wpts.forEach((element) {
      elementLat = element.lat;
      elementLon = element.lon;
      if (elementLat == null || elementLon == null)
        throw Exception(
            '_MapViewState | Should not happen: longitude is null!');
      if (southWest && elementLon < res.longitude) {
        resLon = elementLon;
        res = LatLng(elementLat, elementLon);
      } else if (!southWest && elementLon > res.longitude) {
        resLon = elementLon;
        res = LatLng(elementLat, elementLon);
      }
    });

    res = LatLng(resLat, resLon);

    return res;
  }

  _setMarkers(int walkId) async {
    List<LatLng> markers =
        await DbRouteInterface.getMarkerPositions(walkId: walkId);
    pics = await DbRouteInterface.getPicuturesOfWalk(walkId: walkId);

    //_addMarker(MapRouteInterface.currentPosition);

    for (LatLng marker in markers) {
      _addMarker(marker);
    }
  }

  _addMarker(latlong) {
    print(pics);
    // find corresponding picture
    Picture match = pics.first; // for init purposes; should change
    if (pics.isNotEmpty) {
      for (Picture picture in pics) {
        Gpx position = GpxReader().fromString(picture.location);

        LatLng location = LatLng(
            position.wpts[0].lat as double, position.wpts[0].lon as double);

        if (location == latlong) {
          match = picture;
        }
      }
    }
    // adjust category
    int category = match.category;
    BitmapDescriptor tempIcon;
    if (category == 3) {
      // animal
      tempIcon = _markerIcons.elementAt(1);
    } else if (category == 4) {
      // tree
      tempIcon = _markerIcons.elementAt(2);
    } else if (category == 5) {
      // plant
      tempIcon = _markerIcons.elementAt(3);
    } else if (category == 6) {
      // mushroom
      tempIcon = _markerIcons.elementAt(4);
    } else {
      // other/default
      tempIcon = _markerIcons.elementAt(0);
    }

    // create marker
    final tempMarker = Marker(
      markerId: MarkerId('$latlong'),
      position: LatLng(
        latlong.latitude,
        latlong.longitude,
      ),
      onTap: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    Steckbrief_2(picture: match, navigationID: navigationID)),
            (Route<dynamic> route) => false);
      },
      icon: tempIcon,
    );

    // add marker to map
    setState(
      () {
        _itemMarkers.add(tempMarker);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _markerIcons = new List.empty(growable: true);
    loadMarkerIcons();

    polylinePoints = PolylinePoints();
    _polylines = {};
  }

  void dispose() {
    _polylines = {};

    super.dispose();
  }

  void changeMapStyle() {
    //add String path as parameter
    getJsonMapStyle("assets/mapsBundle/mapsDefaultView.json").then(setMapStyle);
  }

  Future<String> getJsonMapStyle(String path) {
    return rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  void loadMarkerIcons() {
    var resources;
    if (Platform.isIOS) {
      resources = [
        "assets/images/mapIconsIphone/defaultIcon.png",
        "assets/images/mapIconsIphone/animalFootstepIcon.png",
        "assets/images/mapIconsIphone/treeIcon.png",
        "assets/images/mapIconsIphone/plantIcon.png",
        "assets/images/mapIconsIphone/mushroomIcon.png"
      ];
    } else {
      resources = [
        "assets/images/mapIconsAndroid/defaultIcon.png",
        "assets/images/mapIconsAndroid/animalFootstepIcon.png",
        "assets/images/mapIconsAndroid/treeIcon.png",
        "assets/images/mapIconsAndroid/plantIcon.png",
        "assets/images/mapIconsAndroid/mushroomIcon.png"
      ];
    }

    for (String res in resources) {
      BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        res,
      ).then(
        (onValue) {
          _markerIcons.add(onValue);
        },
      );
    }
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
              markers: _itemMarkers,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                MapRouteInterface.walkFinished = true;
                mapController = controller;
                changeMapStyle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
