import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _googleApiKey = 'AIzaSyCuATpRv8lqNTHZIyYb3cAs0mcJC6VF-Zk';

  // Get the Google API key
  static String get googleApiKey => _googleApiKey;

  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    // First check if location permission is granted
    PermissionStatus status = await Permission.location.status;
    
    if (status.isDenied) {
      // Request permission
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings
      await openAppSettings();
      return LocationPermission.deniedForever;
    }

    if (status.isGranted) {
      return LocationPermission.whileInUse;
    }

    return LocationPermission.denied;
  }

  // Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permission
      LocationPermission permission = await requestLocationPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get address from coordinates using Google Geocoding API
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_googleApiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final formattedAddress = result['formatted_address'] ?? 'Location not found';
          return formattedAddress;
        }
      }
      
      return 'Location not found';
    } catch (e) {
      print('Error getting address: $e');
      return 'Unable to get address';
    }
  }

  // Calculate distance between two points
  static double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
