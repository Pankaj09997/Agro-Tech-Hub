import 'dart:convert';
import 'package:agrotech_app/Weather/WeatherModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class WeatherServices {
  final String apiKey;

  WeatherServices(this.apiKey);

  // Fetch weather based on latitude and longitude
  Future<WeatherData?> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey"),
    );
    // Now we can change latitude and longitude dynamically and see how it performs.
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get the current location of the user
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Get the current city based on the coordinates
  Future<String?> getCurrentCity() async {
    try {
      Position position = await getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extract the city name from the placemark
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
