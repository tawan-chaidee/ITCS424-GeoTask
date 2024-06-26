import 'package:flutter/material.dart';
import 'package:geotask/components/map.dart';
import 'package:geotask/components/weather_banner.dart';
import 'package:geotask/model/weather_model.dart';
import 'package:geotask/page/add_page.dart';
import 'package:geotask/page/edit_page.dart';
import 'package:geotask/page/weather_page.dart';
import 'package:geotask/service/location_service.dart';
import 'package:geotask/service/weather_service.dart';
import 'package:geotask/utils/weather_code_2_color.dart';
import 'package:geotask/utils/weather_code_2_text.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:geotask/provider/todo_provider.dart';
import 'package:geolocator/geolocator.dart';
// import '../components/weather_banner.dart';

class TodoDetailPage extends StatefulWidget {
  final String todoIndex;

  TodoDetailPage({required this.todoIndex});

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late WeatherNow todayWeather;
  bool isLoading = true;
  String cityName = '';
  Position? _currentPosition;
  Todo todo = Todo(
      title: "",
      subtitle: "",
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      id: '12345');

  //TODO Make todo keep long lat
  double latitude = 13.736717; //default to Bangkok
  double longitude = 100.523186;
  List<LatLng> points = [];

  @override
  void initState() {
    super.initState();

    // TODO error handling
    print("todo index ${widget.todoIndex}");
    todo = Provider.of<TodoProvider>(context, listen: false)
        .getTodoFromId(widget.todoIndex);
    print(todo.toMap());

    if (todo.locationLatLng != null) {
      _fetchCurrentLocation();
    }

    fetchWeatherData();
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> fetchWeatherData() async {
    if (todo.locationLatLng == null) {
      try {
        await _fetchCurrentLocation();
        latitude = _currentPosition!.latitude;
        longitude = _currentPosition!.longitude;
      } catch (e) {
        print('Error fetching location: $e, using default location');
      }
      // latitude = todo.locationLatLng!.latitude;
      // longitude = todo.locationLatLng!.longitude;
    } else {
      latitude = todo.locationLatLng!.latitude;
      longitude = todo.locationLatLng!.longitude;
    }

    print('fetching weather data for $latitude, $longitude');

    try {
      setState(() {
        isLoading = true;
      });
      cityName = await LocationService().getCity(latitude, longitude);
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
    double screenWidth = MediaQuery.of(context).size.width;
    var dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    print("$latitude  $longitude");

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const EditPage(todoIndex: 2)));
                      builder: (context) => AddPage(editId: todo.id)));
              var newTodo = Provider.of<TodoProvider>(context, listen: false)
                  .getTodoFromId(widget.todoIndex);
              fetchWeatherData();
              setState(() {
                todo = newTodo;
                latitude = todo.locationLatLng!.latitude;
                longitude = todo.locationLatLng!.longitude;
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              todo.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: [
                Text(
                  // 'From: ${todo.startTime} to ${todo.endTime}',
                  'From ${dateFormat.format(todo.startTime)} to ${dateFormat.format(todo.endTime)}',
                  style: const TextStyle(fontSize: 16),
                ),
                // Text(
                //   'id: ${todo.id}',
                //   style: Theme.of(context).textTheme.labelSmall,
                // )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 14, left: 24, right: 24),
                  child: todo.subtitle != null
                      ? Text(
                          todo.subtitle,
                          style: const TextStyle(fontSize: 16),
                        )
                      : const Text(""),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 14, left: 24, right: 24),
                  child: todo.details != null
                      ? Text(
                          todo.details!,
                          style: const TextStyle(fontSize: 16),
                        )
                      : const Text(""),
                )
              ],
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
            child: isLoading
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          EdgeInsets.only(bottom: 20.0), // Adjust as needed
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : WeatherBanner(
                    weatherNow: todayWeather,
                    cityName: cityName,
                  ),
          ),
          Container(
            color: isLoading ? Colors.transparent : weatherCode2Color(todayWeather.condition),
            width: screenWidth,
            height: 40,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Container()
                  : Text(
                      weatherCode2Text(todayWeather.condition),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          Expanded(
            child: StreetMap(
              points: [
                LatLng(latitude, longitude),
              ],
            ),
          )
          // const FullWidthImage(
          //   imageUrl:
          //       'https://www.shutterstock.com/image-vector/map-city-600nw-671959120.jpg',
          // ),
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
