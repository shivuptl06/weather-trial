import 'package:flutter/material.dart';
import 'package:minimal_loginn/services/weather_services.dart';
import 'package:minimal_loginn/models/weather_models.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API Key

  final _weatherService = WeatherServices("3724c424d514c8150b9ba61f42f12dd7");
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    // get Weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    super.initState();

// Fetch Weather Data on App Start
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Weather App')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City Name
            Center(
              child: Text(
                _weather?.cityName ?? 'Loading',
                style: TextStyle(fontSize: 24),
              ),
            ),

            // Temperature
            Center(
              child: Text(
                _weather != null
                    ? "${_weather!.temperature.round()} °C"
                    : 'Loading',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ));
  }
}
