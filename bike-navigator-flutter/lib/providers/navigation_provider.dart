import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:latlong2/latlong.dart';
import '../services/gpx_service.dart';

class NavigationProvider extends ChangeNotifier {
  // State
  List<LatLng> routePoints = [];
  Position? currentPosition;
  bool isNavigating = false;
  bool hasLoadedRoute = false;
  int nextWaypointIndex = 0;
  double distanceToNextPoint = 0;
  double distanceToEnd = 0;
  double totalDistance = 0;
  String? nextInstruction = '';
  bool instructionGiven = false;
  double currentSpeed = 0;
  double bearing = 0;

  final FlutterTts flutterTts = FlutterTts();
  StreamSubscription<Position>? positionStream;

  NavigationProvider() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage("de-DE");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.85);
  }

  // Load GPX from file
  Future<void> loadGPXRoute(String filePath) async {
    try {
      final gpxService = GPXService();
      routePoints = await gpxService.parseGPX(filePath);
      
      if (routePoints.isNotEmpty) {
        totalDistance = _calculateTotalDistance();
        hasLoadedRoute = true;
        nextWaypointIndex = 0;
        distanceToEnd = totalDistance;
        notifyListeners();
        
        // Automatisch Navigation starten
        await startNavigation();
      }
    } catch (e) {
      debugPrint('Error loading GPX: $e');
    }
  }

  // Start navigation
  Future<void> startNavigation() async {
    isNavigating = true;
    nextWaypointIndex = 0;
    instructionGiven = false;
    
    // Request location permissions
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    // Start listening to position updates
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((Position position) {
      currentPosition = position;
      currentSpeed = position.speed * 3.6; // Convert m/s to km/h
      _updateNavigation();
      notifyListeners();
    });

    notifyListeners();
  }

  // Update navigation state
  void _updateNavigation() {
    if (currentPosition == null || routePoints.isEmpty) return;

    final currentLatLng = LatLng(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    // Find closest point on route
    int closestIndex = 0;
    double closestDistance = double.infinity;

    for (int i = nextWaypointIndex; i < routePoints.length; i++) {
      final distance = _getDistance(currentLatLng, routePoints[i]);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    // Update next waypoint
    if (closestIndex >= nextWaypointIndex) {
      nextWaypointIndex = closestIndex;
    }

    // Calculate distances
    if (nextWaypointIndex < routePoints.length - 1) {
      distanceToNextPoint =
          _getDistance(currentLatLng, routePoints[nextWaypointIndex]) / 1000;
      distanceToEnd =
          _calculateDistanceFromIndex(nextWaypointIndex, currentLatLng) / 1000;

      // Calculate bearing to next point
      bearing = _calculateBearing(
        currentLatLng,
        routePoints[nextWaypointIndex],
      );

      // Check for turns and give instructions
      _checkForTurnInstructions();
    }
  }

  // Check for turn instructions
  void _checkForTurnInstructions() {
    if (nextWaypointIndex >= routePoints.length - 5) return;

    // Look ahead 5 points to detect turns
    final currentBearing = bearing;
    final nextBearing = _calculateBearing(
      routePoints[nextWaypointIndex],
      routePoints[nextWaypointIndex + 5],
    );

    final bearingDiff = (nextBearing - currentBearing).abs();
    final normalizedDiff = bearingDiff > 180 ? 360 - bearingDiff : bearingDiff;

    String instruction = '';

    if (normalizedDiff > 15 && normalizedDiff < 45) {
      instruction = normalizedDiff > 0 ? '↗ Leicht rechts' : '↖ Leicht links';
    } else if (normalizedDiff >= 45 && normalizedDiff < 90) {
      instruction = normalizedDiff > 0 ? '→ Rechts' : '← Links';
    } else if (normalizedDiff >= 90 && normalizedDiff < 135) {
      instruction = normalizedDiff > 0 ? '↘ Scharf rechts' : '↙ Scharf links';
    } else if (normalizedDiff >= 135) {
      instruction = '⟲ Kehrturn';
    } else {
      instruction = '↑ Geradeaus';
    }

    // Only update if instruction changed and distance is right
    if (instruction != nextInstruction && distanceToNextPoint < 0.15) {
      nextInstruction = instruction;
      instructionGiven = false;

      // Speak instruction
      if (!instructionGiven) {
        _speakInstruction(instruction);
        instructionGiven = true;
      }
    }
  }

  // Speak instruction via TTS
  Future<void> _speakInstruction(String text) async {
    try {
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS Error: $e');
    }
  }

  // Stop navigation
  Future<void> stopNavigation() async {
    isNavigating = false;
    hasLoadedRoute = false;
    await positionStream?.cancel();
    await flutterTts.stop();
    notifyListeners();
  }

  // Calculate distance in meters
  double _getDistance(LatLng point1, LatLng point2) {
    const double earthRadiusMeters = 6371000;

    final dLat = _toRadian(point2.latitude - point1.latitude);
    final dLng = _toRadian(point2.longitude - point1.longitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadian(point1.latitude)) *
            math.cos(_toRadian(point2.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.asin(math.sqrt(a));
    return earthRadiusMeters * c;
  }

  // Calculate total distance of route
  double _calculateTotalDistance() {
    double total = 0;
    for (int i = 0; i < routePoints.length - 1; i++) {
      total += _getDistance(routePoints[i], routePoints[i + 1]);
    }
    return total;
  }

  // Calculate distance from index to current position
  double _calculateDistanceFromIndex(int startIndex, LatLng currentPoint) {
    double distance = 0;

    // Distance from current point to start of index
    distance += _getDistance(currentPoint, routePoints[startIndex]);

    // Distance along route
    for (int i = startIndex; i < routePoints.length - 1; i++) {
      distance += _getDistance(routePoints[i], routePoints[i + 1]);
    }

    return distance;
  }

  // Calculate bearing between two points
  double _calculateBearing(LatLng from, LatLng to) {
    final dLng = _toRadian(to.longitude - from.longitude);
    final y = math.sin(dLng) * math.cos(_toRadian(to.latitude));
    final x = math.cos(_toRadian(from.latitude)) *
            math.sin(_toRadian(to.latitude)) -
        math.sin(_toRadian(from.latitude)) *
            math.cos(_toRadian(to.latitude)) *
            math.cos(dLng);

    return (_toDegree(math.atan2(y, x)) + 360) % 360;
  }

  double _toRadian(double degree) => degree * math.pi / 180;
  double _toDegree(double radian) => radian * 180 / math.pi;

  @override
  void dispose() {
    positionStream?.cancel();
    flutterTts.stop();
    super.dispose();
  }
}
