import 'package:flutter/material.dart';

IconData weatherCode2Icon(int code) {
  if (code == 0) {
    return Icons.wb_sunny; // Clear sky
  } else if (code >= 1 && code <= 3) {
    return Icons.wb_cloudy; // Mainly clear, partly cloudy, and overcast
  } else if (code == 45 || code == 48) {
    return Icons.cloud; // Fog and depositing rime fog
  } else if (code >= 51 && code <= 55) {
    return Icons.grain; // Drizzle: Light, moderate, and dense intensity
  } else if (code == 56 || code == 57) {
    return Icons.ac_unit; // Freezing Drizzle: Light and dense intensity
  } else if (code >= 61 && code <= 65) {
    return Icons.beach_access; // Rain: Slight, moderate and heavy intensity
  } else if (code == 66 || code == 67) {
    return Icons.blur_on; // Freezing Rain: Light and heavy intensity
  } else if (code >= 71 && code <= 75) {
    return Icons.ac_unit; // Snow fall: Slight, moderate, and heavy intensity
  } else if (code == 77) {
    return Icons.ac_unit; // Snow grains
  } else if (code >= 80 && code <= 82) {
    return Icons.show_chart; // Rain showers: Slight, moderate, and violent
  } else if (code == 85 || code == 86) {
    return Icons.ac_unit; // Snow showers slight and heavy
  } else if ((code >= 95 && code <= 96) || code == 99) {
    return Icons.flash_on; // Thunderstorm: Slight or moderate, Thunderstorm with slight and heavy hail
  } else {
    return Icons.cloud; // Default icon for unknown weather code
  }
}