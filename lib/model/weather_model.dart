import 'package:flutter/material.dart';
import '../utils/weather_code_2_icon.dart';

class WeatherData {
  final WeatherHour weatherHour;
  final WeatherDay weatherDay;
  final WeatherNow weatherNow;

  WeatherData(
      {required this.weatherHour,
      required this.weatherDay,
      required this.weatherNow});
}

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
  final IconData icon;

  WeatherDay({
    required this.day,
    required this.temperature,
    required this.icon,
  });
}

class WeatherNow {
  final IconData condition;
  final int temperature;
  final int feelLike;
  final int pressure;
  final int humidity;
  final int precip;
  final WeatherWind wind;

  WeatherNow({
    required this.condition,
    required this.temperature,
    required this.feelLike,
    required this.pressure,
    required this.humidity,
    required this.precip,
    required this.wind,
  });

  factory WeatherNow.fromJson(Map<String, dynamic> data) {
    return WeatherNow(
      condition: weatherCode2Icon(data['current']['weather_code']),
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
  }
}


class WeatherWind {
  final int windSpeed;
  final int windDirection;

  WeatherWind({
    required this.windSpeed,
    required this.windDirection,
  });
}
