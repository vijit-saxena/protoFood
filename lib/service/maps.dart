import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps {
  static Future<LatLng> getCurrentPosition(GeolocatorPlatform geolocatorPlatform) async {
    final hasPermission = await handlePermission(geolocatorPlatform);

    if (!hasPermission) {
      return const LatLng(25.178409020688036, 75.92163739945082);
    }

    final position = await geolocatorPlatform.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
    // todo : implement hereforth
    // return const LatLng(25.178409020688036, 75.92163739945082);
  }

  static Future<bool> handlePermission(GeolocatorPlatform geolocatorPlatform) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
