import 'package:flutter/material.dart';

Color weatherCode2Color(int code) {
  if ((code >= 80 && code <= 82) || (code >= 95 && code <= 96) || code == 99) {
    return Color.fromARGB(255, 255, 150, 143); // Bad weather color (e.g., red for rain, thunderstorm)
  } else {
    return const Color.fromARGB(255, 130, 247, 189); // Good weather color (e.g., green for clear sky, sunny)
  }
}
