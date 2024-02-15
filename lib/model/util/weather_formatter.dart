
import 'dart:convert';
import 'package:flutter/material.dart';
import '../weather_model.dart';


//https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,surface_pressure,wind_speed_10m,wind_direction_10m
WeatherNow formatWeatherNow(String jsonData) {
  Map<String, dynamic> data = json.decode(jsonData);

  // Extracting current weather information
  WeatherNow weatherNow = WeatherNow(
    condition: Icons.sunny,
    temperature: data['current']['temperature_2m'].toInt(),
    feelLike: data['current']['apparent_temperature'].toInt(),
    pressure: data['current']['surface_pressure'].toInt(),
    humidity: data['current']['relative_humidity_2m'].toInt(),
    precip: data['current']['precipitation'].toInt(),
    wind: WeatherWind(
      windSpeed: data['current']['wind_speed_10m'].toInt(),
      windDirection: data['current']['wind_direction_10m'].toInt(),
    ),
  );

  return weatherNow;   
}

//https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m,rain,snowfall,cloud_cover
List<WeatherHour> formatHourlyWeather(String jsonData) {
  Map<String, dynamic> data = json.decode(jsonData);

  List<WeatherHour> hourWeatherList = [];

  List<String> timeList = List<String>.from(data['hourly']['time']);
  List<double> cloudCoverList = List<double>.from(data['hourly']['cloud_cover']);
  List<double> temperatureList = List<double>.from(data['hourly']['temperature_2m']);
  List<double> rainList = List<double>.from(data['hourly']['rain']);
  List<double> snowfallList = List<double>.from(data['hourly']['snowfall']);

  for (int i = 0; i < timeList.length; i++) {
    String hour = DateTime.parse(timeList[i]).toLocal().hour.toString() + ":00";
    IconData icon = getWeatherIcon(cloudCoverList[i], rainList[i], snowfallList[i]);
    String temperature = temperatureList[i].toStringAsFixed(1) + "°C";

    WeatherHour weatherHour = WeatherHour(hour: hour, icon: icon, temperature: temperature);
    hourWeatherList.add(weatherHour);
  }

  return hourWeatherList;
}



IconData getWeatherIcon(double temperature, double rain, double snowfall) {
  if (snowfall > 0.1) {
    return Icons.ac_unit; // Snowfall icon
  } else if (rain > 0.1) {
    return Icons.waves; // Rain icon
  } else if (temperature < 5) {
    return Icons.ac_unit; // Cold weather icon
  } else if (temperature > 30) {
    return Icons.wb_sunny; // Hot weather icon
  } else {
    return Icons.wb_cloudy; // Default cloudy icon
  }
}



