import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/weather_model.dart';
import '../page/edit_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);
  static const themeBlueGreen = Color.fromRGBO(213, 245, 243, 1);

  // Mock data (This part is copied from the weather page) 
  static WeatherToday todayWeather = WeatherToday(
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {}, 
          ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {Navigator.pop(context);},
          )
        ]
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Consumer<TextInput>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.input1}',
                      style: TextStyle(fontSize: 30),
                    );
                  },
                ),
                Consumer<TextInput>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.input2}',
                      style: TextStyle(fontSize: 25),
                    );
                  },
                ),
                SizedBox(height: 10),
                Consumer<TextInput>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.input3}',
                      style: TextStyle(fontSize: 20),
                    );
                  },
                ),
                SizedBox(height: 10),
                Consumer<TextInput>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.input4}',
                      style: TextStyle(fontSize: 20),
                    );
                  },
                ),
                SizedBox(height: 10),
                Consumer<TextInput>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.input5}',
                      style: TextStyle(fontSize: 20),
                    );
                  },
                ),
                SizedBox(height: 10),

                // The weather banner 
                weatherBanner(context),
                Container(
                  color: const Color.fromARGB(255, 161, 255, 210),
                  width: screenWidth,
                  height: 40,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    // Dynamic text and color to be add later
                    child: const Text(
                      "Safe, low chance of raining: 26%",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Image.asset("assets/appimages/Map.png"),
                )
              ],
            ),
          ), 
        ),
      ),
    );
  }

  // (This part is copied from the weather page) 
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
  // (This part is copied from the weather page) 
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
        color: const Color.fromARGB(255, 161, 255, 210),
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