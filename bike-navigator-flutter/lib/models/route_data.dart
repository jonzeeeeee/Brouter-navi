import 'package:latlong2/latlong.dart';

class RouteData {
  final String name;
  final List<LatLng> points;
  final double totalDistance;
  final double totalElevation;
  final DateTime createdAt;

  RouteData({
    required this.name,
    required this.points,
    required this.totalDistance,
    required this.totalElevation,
    required this.createdAt,
  });
}

class NavigationState {
  final int currentWaypoint;
  final double distanceToNext;
  final double distanceToEnd;
  final double speed;
  final double bearing;
  final String? instruction;

  NavigationState({
    required this.currentWaypoint,
    required this.distanceToNext,
    required this.distanceToEnd,
    required this.speed,
    required this.bearing,
    this.instruction,
  });
}
