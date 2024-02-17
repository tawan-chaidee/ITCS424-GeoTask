import 'package:flutter/material.dart';
import './page/weather_page.dart'; // Import the SecondPage class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (
       WeatherPage(latitude:48.301, longitude:2.5708)
    );
  }
}
