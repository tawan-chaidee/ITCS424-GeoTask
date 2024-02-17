import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geotask/model/weather_model.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  Future<WeatherNow> getWeatherNow(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,surface_pressure,wind_speed_10m,wind_direction_10m'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherNow.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<WeatherHour>> getWeatherHour(
      double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,rain,snowfall,cloud_cover'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<WeatherHour> hourlyData = [];
        List<dynamic> time = data["hourly"]["time"];
        List<double> temperature =
            data["hourly"]["temperature_2m"].cast<double>();
        List<double> rain = data["hourly"]["rain"].cast<double>();
        List<double> snowFall = data["hourly"]["snowfall"].cast<double>();

        //Calculate hour range
        DateTime currentTime = DateTime.now();
        DateTime startTime = currentTime.subtract(const Duration(hours: 3));
        DateTime endTime = currentTime.add(Duration(hours: 3));

        //Create List of WeatherHour
        for (int i = 0; i < time.length; i++) {
          DateTime currentTime = DateTime.parse(time[i]);

          //Filter unwanted hour
          if (currentTime.isAtSameMomentAs(startTime) ||
              (currentTime.isAfter(startTime) &&
                  currentTime.isBefore(endTime)) ||
              currentTime.isAtSameMomentAs(endTime)) {
            hourlyData.add(
              WeatherHour(
                hour: convertToHourMinute(time[i]),
                icon: Icons.sunny, // ICON LOGIC TO DO!!!
                temperature: '${temperature[i].toString()}°',
              ),
            );
          }
        }

        return hourlyData;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<WeatherDay>> getWeatherDay(
      double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,weathercode'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<WeatherDay> dailyData = [];
        List<dynamic> time = data["daily"]["time"];
        List<double> maxTemperature =
            data["daily"]["temperature_2m_max"].cast<double>();
        List<double> minTemperature =
            data["daily"]["temperature_2m_min"].cast<double>();
        List<int> weatherCode = data["daily"]["weathercode"].cast<int>();

        for (int i = 0; i < time.length; i++) {
          dailyData.add(
            WeatherDay(
              day: _convertToDay(time[i]),
              //Find avg of min max temp
              temperature:
                  '${(maxTemperature[i] - minTemperature[i]).toStringAsFixed(1)}°',
              icon: _getWeatherCondition(weatherCode[i]),
            ),
          );
        }

        return dailyData;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String _convertToDay(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('EEEE').format(dateTime);
  }

  IconData _getWeatherCondition(int code) {
    //TODO

    // if (code == 800) {
    //   return 'Clear';
    // } else if (code >= 200 && code <= 232) {
    //   return 'Thunderstorm';
    // } else if (code >= 300 && code <= 321) {
    //   return 'Drizzle';
    // } else if (code >= 500 && code <= 531) {
    //   return 'Rain';
    // } else if (code >= 600 && code <= 622) {
    //   return 'Snow';
    // } else {
    //   return 'Unknown';
    // }
    return Icons.sunny;
  }
}

//Convert ISO date format
String convertToHourMinute(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedTime = DateFormat('H:mm').format(dateTime);
  return formattedTime;
}
