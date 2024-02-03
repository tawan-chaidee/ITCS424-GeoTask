import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        children: [
          Container(
            width: 400,
            height: 300,
            color: Color.fromARGB(255, 225, 255, 0),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                //Top info part
                children: [
                  _weather_box(100, 100, Colors.blue, 15.0, 'test', 'test'),
                  _weather_box(100, 100, Colors.green, 20.0, 'test', 'test'),
                  _weather_box(200, 100, Color.fromARGB(255, 250, 0, 88), 20.0,
                      '', '', Text('test')),
                ],
              ),
            ),
          ),
          //Bottom weather Table part
          _weather_box(400, 250, Color.fromARGB(255, 242, 0, 255), 15, '', '', _weatherTable()),
          _weather_box(400, 120, Colors.blue, 15, '', '', _hourWeatherTable()),
        ],
      ),
    );
  }

  // Roundy box with title and subtitle, can take widget as child if
  // "customWidget" parameter is provided
  Widget _weather_box(
    double width,
    double height,
    Color color,
    double borderRadius,
    String title,
    String subtitle, [
    Widget? customWidget,
  ]) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customWidget != null) customWidget,
          if (customWidget == null)
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget _weatherTable() {
  List<Map<String, dynamic>> weatherData = [
    {
      'day': 'Monday',
      'temperature': '25°C',
      'condition': 'Sunny',
      'icon': Icons.wb_sunny
    },
    {
      'day': 'Tuesday',
      'temperature': '22°C',
      'condition': 'Cloudy',
      'icon': Icons.cloud
    },
    {
      'day': 'Wednesday',
      'temperature': '28°C',
      'condition': 'Partly Cloudy',
      'icon': Icons.wb_cloudy
    },
  ];

  return DataTable(
    columns: [
      DataColumn(label: Text('Day')),
      DataColumn(label: Text('Temperature')),
      DataColumn(label: Text('Condition')),
    ],
    rows: weatherData
        .map(
          (data) => DataRow(
            cells: [
              DataCell(Text(data['day'])),
              DataCell(Text(data['temperature'])),
              DataCell(Icon(data['icon'], color: Colors.pink, size: 24.0)),
            ],
          ),
        )
        .toList(),
  );
}

Widget _hourWeatherTable() {
  List<Map<String, dynamic>> weatherData = [
    {'hour': '14:00', 'icon': Icons.wb_sunny, 'temperature': '32°C'},
    {'hour': '15:00', 'icon': Icons.cloud, 'temperature': '31°C'},
    {'hour': '16:00', 'icon': Icons.wb_cloudy, 'temperature': '35°C'},
  ];

  return Container(
    padding: EdgeInsets.all(16.0),
    child: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weatherData.map((data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['hour']),
                SizedBox(height: 8.0),
                Icon(data['icon'], color: Colors.pink, size: 24.0),
                SizedBox(height: 8.0),
                Text(data['temperature']),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
