import 'dart:math';

import 'package:flutter/material.dart';
import '../model/weather_model.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);
  static const themeBlueGreen = Color.fromRGBO(213, 245, 243, 1);

  // Mock data for tempory use
  static List<WeatherHour> mockHourWeatherList = [
    WeatherHour(hour: '14:00', icon: Icons.wb_sunny, temperature: '32°C'),
    WeatherHour(hour: '15:00', icon: Icons.cloud, temperature: '31°C'),
    WeatherHour(hour: '16:00', icon: Icons.wb_cloudy, temperature: '35°C'),
    WeatherHour(hour: '17:00', icon: Icons.wb_cloudy, temperature: '35°C'),
    WeatherHour(hour: '18:00', icon: Icons.wb_cloudy, temperature: '35°C'),
  ];

  // Mock data for tempory use
  static List<WeatherDay> mockDayWeatherList = [
    WeatherDay(
        day: 'Monday',
        temperature: '25°C',
        condition: 'Sunny',
        icon: Icons.wb_sunny),
    WeatherDay(
        day: 'Tuesday',
        temperature: '22°C',
        condition: 'Cloudy',
        icon: Icons.cloud),
    WeatherDay(
        day: 'Wednesday',
        temperature: '28°C',
        condition: 'Partly Cloudy',
        icon: Icons.wb_cloudy),
    WeatherDay(
        day: 'Thursday',
        temperature: '28°C',
        condition: 'Partly Cloudy',
        icon: Icons.wb_cloudy),
    WeatherDay(
        day: 'Friday',
        temperature: '28°C',
        condition: 'Partly Cloudy',
        icon: Icons.wb_cloudy),
  ];

  // Mock data for tempory use
  static WeatherNow todayWeather = WeatherNow(
    condition: Icons.thunderstorm,
    temperature: 25,
    feelLike: 44,
    pressure: 1013,
    humidity: 60,
    precip: 0,
    wind: WeatherWind(
      windSpeed: 10,
      windDirection: 45,
    ),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Color.fromARGB(255, 161, 255, 210),
                width: screenWidth,
                height: 40,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  // Dynamic text and color to be add later
                  child: const Text(
                    "Safe, low chance of raining: 26%",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //Top weather banner
              weatherBanner(context),
              Container(
                width: screenWidth,
                height: 220,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      _weatherBox(
                        (screenWidth / 2) - 25,
                        100,
                        color: themeBlueGreen,
                        borderRadius: 15.0,
                        title: 'Feel Like',
                        subtitle1: todayWeather.feelLike.toString() + '°C',
                      ),
                      _weatherBox((screenWidth / 2) - 25, 100,
                          color: themeBlueGreen,
                          borderRadius: 20.0,
                          title: 'Pressure',
                          subtitle1:
                              "${todayWeather.pressure.toString()} mbar"),
                      _weatherBox(
                        screenWidth - 40,
                        100,
                        color: themeBlueGreen,
                        borderRadius: 20.0,
                        title: '',
                        subtitle1: '',
                        customChild: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _weatherBox(
                              100,
                              100,
                              title: "Wind",
                              subtitle1:
                                  'Speed: ${todayWeather.wind.windSpeed}',
                              subtitle2: 'Direction: ',
                            ),
                            _weatherBox(
                              140,
                              100,
                              title: '',
                              subtitle1: '',
                              //Arrow Direction to be implemented later
                              customChild: const Icon(
                                Icons.arrow_forward,
                                size: 48,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Bottom hourly weather Table part
              Container(
                height: 120,
                width: screenWidth,
                child: _hourWeatherTable(mockHourWeatherList),
              ),
              //Very bottom day weather Table part
              Container(
                height: 400,
                width: screenWidth,
                padding: EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: themeBlueGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: _weatherTable(mockDayWeatherList),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget weatherBanner(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth - 48,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            customChild: Icon(
              todayWeather.condition,
              size: 52,
            ),
          ),
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            title: 'BangKok',
            subtitle1: '25°C',
          ),
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            title: "Sunny",
            subtitle1: "Humidity: ${todayWeather.humidity.toString()}%",
            subtitle2: "Precip: ${todayWeather.precip.toString()}%",
          ),
        ],
      ),
    );
  }

  // Roundy box component with title and subtitle
  // Would display second subtitle or customWidget if provided
  // Also optionaly take color as parameter
  Widget _weatherBox(
    double width,
    double height, {
    Color? color,
    double borderRadius = 0,
    String title = '',
    String subtitle1 = '',
    String? subtitle2,
    Widget? customChild,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customChild != null) customChild,
          if (customChild == null)
            Column(
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (subtitle1.isNotEmpty)
                  Text(
                    subtitle1,
                    style: const TextStyle(fontSize: 16),
                  ),
                if (subtitle2 != null && subtitle2.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: Text(
                      subtitle2,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // Day table
  Widget _weatherTable(List<WeatherDay> weatherData) {
    return DataTable(
      dataRowMaxHeight: 60.0,
      columns: const [
        DataColumn(
          label: Text(
            'Day',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Temperature',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Condition',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows: weatherData
          .map(
            (data) => DataRow(
              cells: [
                DataCell(
                  Text(
                    data.day,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                DataCell(
                  Text(
                    data.temperature,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                DataCell(
                  Icon(
                    data.icon,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    size: 24.0,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  // Hour table
  Widget _hourWeatherTable(List<WeatherHour> weatherData) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weatherData.map((data) {
              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.hour),
                    const SizedBox(height: 8.0),
                    Icon(data.icon,
                        color: const Color.fromARGB(255, 0, 0, 0), size: 24.0),
                    const SizedBox(height: 8.0),
                    Text(data.temperature),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
