import 'package:flutter/material.dart';
import 'package:geotask/page/weather_page.dart';
import 'package:geotask/provider/todo_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'GeoTask',
        home: WeatherPage(latitude:48.301, longitude:2.5708),
        // TodoDetailPage(todoIndex: 1),
        
      ),
    );
  }
}