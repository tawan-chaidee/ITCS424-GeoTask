import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geotask/utils/weather_code_2_icon.dart';
import 'package:geotask/utils/weather_code_2_text.dart';
import '../model/weather_model.dart';
import '../service/weather_service.dart';
import '../service/location_service.dart';

class WeatherPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  WeatherPage({required this.latitude, required this.longitude});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  static const themeBlueGreen = Color.fromRGBO(213, 245, 243, 1);
  bool isLoading = true;
  // WeatherNow? weatherNow;

  WeatherService weatherService = WeatherService();

  late String cityName = '';
  late WeatherNow todayWeather = WeatherNow(
      condition: 42,
      temperature: 0,
      feelLike: 0,
      pressure: 0,
      humidity: 0,
      precip: 0,
      wind: WeatherWind(windSpeed: 0, windDirection: 0));
  late List<WeatherHour> hourWeatherList = [];
  late List<WeatherDay> dayWeatherList = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData(widget.latitude, widget.longitude);
  }

  Future<void> fetchWeatherData(double latitude, double longitude) async {
    try {
      setState(() {
        isLoading = true;
      });

      cityName = await LocationService().getCity(latitude, longitude);

      todayWeather = await weatherService.getWeatherNow(latitude, longitude);
      hourWeatherList =
          await weatherService.getWeatherHour(latitude, longitude);
      dayWeatherList = await weatherService.getWeatherDay(latitude, longitude);
    } catch (e) {
      print('Error fetching weather data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Loading indicator
              if (isLoading)
                Container(
                  height: 200, // Set the height based on your design
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 161, 255, 210),
                      width: screenWidth,
                      height: 40,
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text(
                          weatherCode2Text(todayWeather.condition),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                              subtitle1:
                                  todayWeather.feelLike.toString() + '°C',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                    Container(
                      height: 120,
                      width: screenWidth,
                      child: _hourWeatherTable(hourWeatherList),
                    ),
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
                      child: _weatherTable(dayWeatherList),
                    ),
                  ],
                ),
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
              weatherCode2Icon(todayWeather.condition),
              size: 52,
            ),
          ),
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            title: cityName,
            subtitle1: "${todayWeather.temperature} °Cr",
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

  //TODO: Refractor to component

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
