// ignore_for_file: dead_code, deprecated_member_use

import 'dart:convert';

import 'package:geocoding/geocoding.dart';

import '../models/weather_models.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherServices {
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Current Position: ${position.latitude}, ${position.longitude}");

      // Convert Position to Placemark
      List<Placemark> placemarks =
          await placemarkFromCoordinates(43.4171116, -80.4685411);
      print("Placemark Response: $placemarks");

      if (placemarks.isNotEmpty && placemarks[0].locality != null) {
        // Extract City Name from first placemark
        String? cityName = placemarks[0].locality;
        print("City Name: $cityName");
        return cityName!;
      } else {
        return "Unknown City";
      }
    } catch (e) {
      print("Error getting location: ${e.toString()}");
      return "Unknown City";
    }
  }

  Future<Weather> getWeather(String cityName) async {
    print("City Name for Weather API: $cityName");

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
