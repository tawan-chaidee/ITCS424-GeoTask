import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

// Function to map weather codes to corresponding icons
IconData weatherCode2Icon(int code) {
  DateTime now = DateTime.now();
  int hour = now.hour;
  bool isNight = hour < 6 || hour >= 18; // Assuming 6 AM to 6 PM as daytime

  if (code == 0) {
    return isNight
        ? WeatherIcons.night_clear
        : WeatherIcons.day_sunny; // Clear sky
  } else if (code >= 1 && code <= 3) {
    return isNight
        ? WeatherIcons.night_clear
        : WeatherIcons.day_sunny; // Mainly clear, partly cloudy, and overcast
  } else if ((code >= 45 && code <= 48) || (code >= 51 && code <= 55)) {
    return isNight
        ? WeatherIcons.night_fog
        : WeatherIcons.day_fog; // Fog and depositing rime fog
  } else if ((code >= 56 && code <= 57) || (code >= 61 && code <= 65)) {
    return isNight
        ? WeatherIcons.night_snow
        : WeatherIcons.day_snow; // Freezing Drizzle: Light and dense intensity
  } else if ((code >= 66 && code <= 67) ||
      (code >= 71 && code <= 75) ||
      code == 77) {
    return isNight
        ? WeatherIcons.night_snow
        : WeatherIcons.snow; // Snow fall: Slight, moderate, and heavy intensity
  } else if ((code >= 80 && code <= 82) || (code >= 85 && code <= 86)) {
    return isNight
        ? WeatherIcons.night_rain
        : WeatherIcons.day_rain; // Rain showers: Slight, moderate, and violent
  } else if ((code >= 95 && code <= 96) || code == 99) {
    return isNight
        ? WeatherIcons.day_thunderstorm
        : WeatherIcons
            .night_thunderstorm; // Thunderstorm: Slight or moderate, Thunderstorm with slight and heavy hail
  } else {
    return isNight
        ? WeatherIcons.night_clear
        : WeatherIcons.day_sunny; // Default icon for unknown weather code
  }
}
