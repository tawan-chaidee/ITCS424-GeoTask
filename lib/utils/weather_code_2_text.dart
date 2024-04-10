import 'package:flutter/material.dart';

String weatherCode2Text(int code) {
  if (code == 0) {
    return "Clear sky";
  } else if (code >= 1 && code <= 3) {
    return "Partly cloudy"; // Mainly clear, partly cloudy, and overcast
  } else if ((code >= 45 && code <= 48) || (code >= 51 && code <= 55)) {
    return "Fog"; // Fog and depositing rime fog
  } else if ((code >= 56 && code <= 57) || (code >= 61 && code <= 65)) {
    return "Freezing Drizzle"; // Freezing Drizzle: Light and dense intensity
  } else if ((code >= 66 && code <= 67) ||
      (code >= 71 && code <= 75) ||
      code == 77) {
    return "Snow"; // Snow fall: Slight, moderate, and heavy intensity
  } else if ((code >= 80 && code <= 82) || (code >= 85 && code <= 86)) {
    return "Rain"; // Rain showers: Slight, moderate, and violent
  } else if ((code >= 95 && code <= 96) || code == 99) {
    return "Thunderstorm"; // Thunderstorm: Slight or moderate, Thunderstorm with slight and heavy hail
  } else {
    return "Unknown"; // Default text for unknown weather code
  }
}
