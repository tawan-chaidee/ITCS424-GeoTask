import 'package:flutter/material.dart';
import 'package:geotask/model/weather_model.dart';

class WeatherBanner extends StatefulWidget {
  final WeatherNow weatherNow;
  final String cityName;

  WeatherBanner({required this.weatherNow, required this.cityName});

  @override
  _WeatherBannerState createState() => _WeatherBannerState();
}

class _WeatherBannerState extends State<WeatherBanner> {
  static const themeBlueGreen = Color.fromRGBO(213, 245, 243, 1);

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
              widget.weatherNow.condition,
              size: 52,
            ),
          ),
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            title: widget.cityName,
            subtitle1: "${widget.weatherNow.temperature} °Cr",
          ),
          _weatherBox(
            screenWidth / 3 - 16,
            100,
            title: "Sunny",
            subtitle1: "Humidity: ${widget.weatherNow.humidity.toString()}%",
            subtitle2: "Precip: ${widget.weatherNow.precip.toString()}%",
          ),
        ],
      ),
    );
  }

  // Roundy box component with title and subtitle
  // Would display second subtitle or customWidget if provided
  // Also optionally take color as a parameter
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
