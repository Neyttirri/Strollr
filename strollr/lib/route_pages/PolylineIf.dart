import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';

class PolylineIf{
  static Gpx gpx = Gpx();
  static bool walkFinished = false;
  static Position? currentPosition;

  Position? getPosition(){
    return currentPosition;
  }

  setPosition(Position? position){
    currentPosition = position;
  }
}