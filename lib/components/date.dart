import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum WeatherType { sunny, cloudy, rainy, snowy }

Icon getWeatherIcon(WeatherType type) {
  switch (type) {
    case WeatherType.sunny:
      return const Icon(Icons.wb_sunny);
    case WeatherType.cloudy:
      return const Icon(Icons.cloud);
    case WeatherType.rainy:
      return const Icon(Icons.beach_access);
    case WeatherType.snowy:
      return const Icon(Icons.ac_unit);
  }
}

class DateHeader extends StatelessWidget {
  final DateTime date;

  DateHeader(this.date);

  fetchWeather() {
    // Fetch weather data from the internet
    return [WeatherType.cloudy, 32];
  }

  @override
  Widget build(BuildContext context) {
    var weather = fetchWeather();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            DateFormat('EEEE, d MMMM y').format(date),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            children: [
              getWeatherIcon(weather[0]),
              SizedBox(width: 8),
              Text(
                '${weather[1]}°C',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
