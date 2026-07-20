import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/navigation_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late MapController mapController;
  bool showMap = true;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<NavigationProvider>(
        builder: (context, navProvider, _) {
          return Stack(
            children: [
              // Map View (in Graustufen für Schwarz-Weiß-Design)
              if (showMap && navProvider.routePoints.isNotEmpty)
                ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, // R
                    0.2126, 0.7152, 0.0722, 0, 0, // G
                    0.2126, 0.7152, 0.0722, 0, 0, // B
                    0, 0, 0, 1, 0, // A
                  ]),
                  child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: navProvider.currentPosition != null
                        ? LatLng(
                            navProvider.currentPosition!.latitude,
                            navProvider.currentPosition!.longitude,
                          )
                        : navProvider.routePoints[0],
                    initialZoom: 16,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'bike_navigator',
                      tileSize: 256,
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: navProvider.routePoints,
                          strokeWidth: 3,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                    // Current position marker
                    if (navProvider.currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              navProvider.currentPosition!.latitude,
                              navProvider.currentPosition!.longitude,
                            ),
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                ),
              // Navigation HUD Overlay
              SafeArea(
                child: Column(
                  children: [
                    // Top Info Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Distance to End
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VERBLEIBEND',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '${navProvider.distanceToEnd.toStringAsFixed(1)} km',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(fontSize: 36),
                              ),
                            ],
                          ),
                          // Speed
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'GESCHWINDIGKEIT',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '${navProvider.currentSpeed.toStringAsFixed(1)} km/h',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(fontSize: 36),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Center Instruction
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            navProvider.nextInstruction ?? '↑',
                            style:
                                Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 100,
                                      color: Colors.white,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'in ${navProvider.distanceToNextPoint.toStringAsFixed(2)} km',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Bottom Controls
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Map Toggle
                          GestureDetector(
                            onTap: () {
                              setState(() => showMap = !showMap);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                showMap ? '🗺' : '🔍',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          // Stop Navigation
                          GestureDetector(
                            onTap: () async {
                              await navProvider.stopNavigation();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '■',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
