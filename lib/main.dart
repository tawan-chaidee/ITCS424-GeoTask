import 'package:flutter/material.dart';
import 'package:geotask/page/home_page.dart';
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
        home: HomePage(title: 'GeoTask'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF70AAA7)),
          textTheme: Typography.blackHelsinki,
          useMaterial3: true,
        )
      ),
    );
  }
}