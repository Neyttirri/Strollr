import 'dart:ffi';

class RouteListCard {
  DateTime routeTime;
  String routeLocation;
  String routeName;
  double routeDuration;
  double routeDistance;

  RouteListCard(this.routeTime, this.routeLocation, this.routeName, this.routeDuration, this.routeDistance);
}