import 'package:flutter/material.dart';
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
  WeatherService weatherService = WeatherService();

  late String cityName = '';
  late WeatherNow todayWeather;
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

      cityName = await LocationService().getLocation(latitude, longitude);

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
                        child: const Text(
                          "Safe, low chance of raining: 26%",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    WeatherBanner(
                      todayWeather: todayWeather,
                      cityName: cityName,
                    ),
                    Container(
                      width: screenWidth,
                      height: 220,
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: [
                            // ... rest of the code remains the same
                          ],
                        ),
                      ),
                    ),
                    // ... rest of the code remains the same
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherBanner extends StatelessWidget {
  final WeatherNow todayWeather;
  final String cityName;

  WeatherBanner({required this.todayWeather, required this.cityName});

  @override
  Widget build(BuildContext context) {
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
            title: cityName.length > 16
                ? '${cityName.substring(0, 16)}...'
                : cityName,
            subtitle1: "${todayWeather.temperature} °C",
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
}
