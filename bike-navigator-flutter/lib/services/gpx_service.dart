import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';

class GPXService {
  Future<List<LatLng>> parseGPX(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      
      final document = xml.XmlDocument.parse(content);
      final points = <LatLng>[];

      // Parse track points
      final trkpts = document.findAllElements('trkpt');
      for (final trkpt in trkpts) {
        final lat = double.tryParse(trkpt.getAttribute('lat') ?? '');
        final lon = double.tryParse(trkpt.getAttribute('lon') ?? '');
        
        if (lat != null && lon != null) {
          points.add(LatLng(lat, lon));
        }
      }

      // If no track points, try waypoints
      if (points.isEmpty) {
        final wpts = document.findAllElements('wpt');
        for (final wpt in wpts) {
          final lat = double.tryParse(wpt.getAttribute('lat') ?? '');
          final lon = double.tryParse(wpt.getAttribute('lon') ?? '');
          
          if (lat != null && lon != null) {
            points.add(LatLng(lat, lon));
          }
        }
      }

      return points;
    } catch (e) {
      throw Exception('Failed to parse GPX file: $e');
    }
  }

  Future<List<LatLng>> parseGPXFromString(String gpxString) async {
    try {
      final document = xml.XmlDocument.parse(gpxString);
      final points = <LatLng>[];

      // Parse track points
      final trkpts = document.findAllElements('trkpt');
      for (final trkpt in trkpts) {
        final lat = double.tryParse(trkpt.getAttribute('lat') ?? '');
        final lon = double.tryParse(trkpt.getAttribute('lon') ?? '');
        
        if (lat != null && lon != null) {
          points.add(LatLng(lat, lon));
        }
      }

      // If no track points, try waypoints
      if (points.isEmpty) {
        final wpts = document.findAllElements('wpt');
        for (final wpt in wpts) {
          final lat = double.tryParse(wpt.getAttribute('lat') ?? '');
          final lon = double.tryParse(wpt.getAttribute('lon') ?? '');
          
          if (lat != null && lon != null) {
            points.add(LatLng(lat, lon));
          }
        }
      }

      return points;
    } catch (e) {
      throw Exception('Failed to parse GPX: $e');
    }
  }
}
