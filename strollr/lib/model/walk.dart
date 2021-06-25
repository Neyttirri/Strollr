final String tableWalks = 'walks';

class WalkField {
  static final List<String> values = [
    id,
    name,
    duration,
    distance,
    route,
    startedAt,
    endedAt
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String duration = 'duration';
  static final String distance = 'distance';
  static final String route = 'route';
  static final String startedAt = 'started_at';
  static final String endedAt = 'ended_at';
}

// duration is a String with format "hh:mm:ss"
// route is a String -> the xml file from Gpx
class Walk {
  int? id;
  String name;
  String durationTime;
  double distanceInKm;
  String route;
  DateTime startedAtTime;
  DateTime endedAtTime;

  Walk({
    this.id,
    required this.name,
    required this.durationTime,
    required this.distanceInKm,
    required this.route,
    required this.startedAtTime,
    required this.endedAtTime,
  });

  /// convert the current walk object to json format to insert it into the database
  Map<String, Object?> toJson() => {
        WalkField.id: id,
        WalkField.name: name,
        WalkField.duration: durationTime,
        WalkField.distance: distanceInKm,
        WalkField.route: route,
        WalkField.startedAt: startedAtTime.toIso8601String(),
        WalkField.endedAt: endedAtTime.toIso8601String(),
      };

  /// convert json input from the database into a walk object
  static Walk fromJson(Map<String, Object?> json) => Walk(
        id: json[WalkField.id] as int?,
        name: json[WalkField.name] as String,
        durationTime: json[WalkField.duration] as String,
        distanceInKm: json[WalkField.distance] as double,
        route: json[WalkField.route] as String,
        startedAtTime: DateTime.parse(json[WalkField.startedAt] as String),
        endedAtTime: DateTime.parse(json[WalkField.endedAt] as String),
      );

  /// creating a copy of the current walk object
  Walk copy({
    int? id,
    String? name,
    String? durationTime,
    double? distanceInKm,
    String? route,
    DateTime? startedAtTime,
    DateTime? endedAtTime,
  }) =>
      Walk(
        id: id ?? this.id,
        name: name ?? this.name,
        durationTime: durationTime ?? this.durationTime,
        distanceInKm: distanceInKm ?? this.distanceInKm,
        route: route ?? this.route,
        startedAtTime: startedAtTime ?? this.startedAtTime,
        endedAtTime: endedAtTime ?? this.endedAtTime,
      );
}
