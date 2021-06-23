import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';

class MapRouteInterface{
  static Gpx gpx = Gpx();
  static bool walkFinished = true;
  static bool walkPaused = true;
  static Position? currentPosition;

  Position? getPosition(){
    return currentPosition;
  }

  setPosition(Position? position){
    currentPosition = position;
  }
}