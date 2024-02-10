import 'package:flutter/material.dart';

class WeatherHour {
  final String hour;
  final IconData icon;
  final String temperature;

  WeatherHour({
    required this.hour,
    required this.icon,
    required this.temperature,
  });
}

class WeatherDay {
  final String day;
  final String temperature;
  final String condition;
  final IconData icon;

  WeatherDay({
    required this.day,
    required this.temperature,
    required this.condition,
    required this.icon,
  });
}

class WeatherToday {
  final IconData condition;
  final int temperature;
  final int feelLike;
  final int pressure;
  final int humidity;
  final int precip;
  final WeatherWind wind;

  WeatherToday({
    required this.condition,
    required this.temperature,
    required this.feelLike,
    required this.pressure,
    required this.humidity,
    required this.precip,
    required this.wind,
  });
}

class WeatherWind {
  final int windSpeed;
  final int windDirection;

  WeatherWind({
    required this.windSpeed,
    required this.windDirection,
  });
}
