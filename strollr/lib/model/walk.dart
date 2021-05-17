final String tableWalks = 'walks';

class WalkField {
  static final String id = '_id';
  static final String name = 'name';
  static final String duration = 'duration';
  static final String distance = 'distance';
  static final String route = 'route';
  static final String started_at = 'started_at';
  static final String ended_at = 'ended_at';

}

class Walk {
  final int? id;
  final String name;
  final String duration;
  final String distance;
  final int route;
  final String started_at;
  final String ended_at;

  const Walk({
    this.id,
    required this.name,
    required this.duration,
    required this.distance,
    required this.route,
    required this.started_at,
    required this.ended_at,
  });
}