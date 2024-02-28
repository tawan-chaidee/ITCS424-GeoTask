import 'package:flutter/material.dart';
import 'package:geotask/model/weather_model.dart';
import 'package:geotask/page/weather_page.dart';
import 'package:geotask/service/location_service.dart';
import 'package:geotask/service/weather_service.dart';
import 'package:provider/provider.dart';
import '../model/todo_model.dart';
import '../provider/todo_provider.dart';
import '../components/weather_banner.dart';

class TodoDetailPage extends StatefulWidget {
  final int todoIndex;

  TodoDetailPage({required this.todoIndex});

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late WeatherNow todayWeather;
  bool isLoading = true;
  String cityName = '';

  //TODO Make todo keep long lat
  double latitude = 50;
  double longitude = 50;

  @override
  void initState() {
    super.initState();

    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      setState(() {
        isLoading = true;
      });
      // TODO: Replace with actual latitude and longitude
      //It will be better to store city in todo but this will ddo
      cityName = await LocationService().getLocation(latitude, longitude);
      todayWeather = await WeatherService().getWeatherNow(latitude, longitude);
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
    final Todo todo =
        Provider.of<TodoProvider>(context).todoList[widget.todoIndex];
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    todo.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 16.0, right: 16.0),
                  child: Text(
                    'From: ${todo.startTime} to ${todo.endTime}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 14, left: 24, right: 24),
                    child: todo.details != null
                        ? Text(
                            todo.details!,
                            style: const TextStyle(fontSize: 16),
                          )
                        : Text(""),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeatherPage(
                                longitude: longitude,
                                latitude: latitude,
                              )),
                    );
                  },
                  child: WeatherBanner(
                    todayWeather: todayWeather,
                    cityName: cityName,
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 161, 255, 210),
                  width: screenWidth,
                  height: 40,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Safe, low chance of raining: 26%",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const FullWidthImage(
                  imageUrl:
                      'https://www.shutterstock.com/image-vector/map-city-600nw-671959120.jpg',
                ),
              ],
            ),
    );
  }
}

class FullWidthImage extends StatelessWidget {
  final String imageUrl;
  const FullWidthImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.network(
        imageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
