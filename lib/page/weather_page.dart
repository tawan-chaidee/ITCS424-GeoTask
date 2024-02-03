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
  ];

  // Mock data for tempory use
  static WeatherToday todayWeather = WeatherToday(
    condition: 'Sunny',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        children: [
          //Top weather banner
          weatherBanner(),
          Container(
            width: 400,
            height: 220,
            // color: const Color.fromARGB(255, 225, 255, 0),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                //Middle info part
                children: [
                  _weatherBox(
                    170,
                    100,
                    color: themeBlueGreen,
                    borderRadius: 15.0,
                    title: 'Feel Like',
                    subtitle1: todayWeather.feelLike.toString() + '°C',
                  ),
                  _weatherBox(170, 100,
                      color: themeBlueGreen,
                      borderRadius: 20.0,
                      title: 'Pressure',
                      subtitle1: "${todayWeather.pressure.toString()} mbar"),
                  _weatherBox(
                    350,
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
                          borderRadius: 0,
                          title: "Wind",
                          subtitle1: 'Speed: ${todayWeather.wind.windSpeed}',
                          subtitle2: 'Direction: ',
                        ),
                        _weatherBox(
                          140,
                          100,
                          borderRadius: 0,
                          title: '',
                          subtitle1: '',
                          //Arrow Direction to be implement later
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
            width: 400,
            child: _hourWeatherTable(mockHourWeatherList),
          ),
          //Very bottom day weather Table part
          Container(
            height: 260,
            width: 400,
            decoration: const BoxDecoration(
              color: themeBlueGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: _weatherTable(mockDayWeatherList),
          )
        ],
      ),
    );
  }

  Widget weatherBanner() {
    return Container(
      width: 400,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 100,
            height: 100,
            child: const Icon(
              Icons.wb_cloudy,
              size: 52,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            child: _weatherBox(
              150,
              100,
              borderRadius: 0,
              title: 'BangKok',
              subtitle1: '25°C',
            ),
          ),
          Container(
              width: 120,
              height: 100,
              //Custom Weather text depend on situtation to be add later
              child: _weatherBox(120, 100,
                  title: "Sunny",
                  subtitle1: "Humidity: ${todayWeather.humidity.toString()}%",
                  subtitle2: "Precip: ${todayWeather.precip.toString()}%")),
        ],
      ),
    );
  }

  // Roundy box with title and subtitle
  // Would display second subtitle or customWidget if provided
  // Also optionaly take color as parameter
  Widget _weatherBox(
    double width,
    double height, {
    Color? color,
    double borderRadius = 0,
    required String title,
    required String subtitle1,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle1,
                  style: const TextStyle(fontSize: 16),
                ),
                if (subtitle2 != null)
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

  Widget _weatherTable(List<WeatherDay> weatherData) {
    return DataTable(
      columns: [
        const DataColumn(label: Text('Day')),
        const DataColumn(label: Text('Temperature')),
        const DataColumn(label: Text('Condition')),
      ],
      rows: weatherData
          .map(
            (data) => DataRow(
              cells: [
                DataCell(Text(data.day)),
                DataCell(Text(data.temperature)),
                DataCell(
                  Icon(data.icon,
                      color: const Color.fromARGB(255, 0, 0, 0), size: 24.0),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

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
