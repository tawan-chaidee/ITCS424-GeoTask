import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Todo_model.dart';
import '../provider/todo_provider.dart';
import '../page/weather_page.dart';


class TodoDetailPage extends StatelessWidget {
  final int todoIndex;

  TodoDetailPage({required this.todoIndex});

  @override
  Widget build(BuildContext context) {
    final Todo todo = Provider.of<TodoProvider>(context).todoList[todoIndex];
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              todo.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
            child: Text(
              'From: ${todo.startTime} to ${todo.endTime}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14, left: 24, right: 24),
              child: Text(
                todo.details,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(213, 245, 243, 1),
            child: WeatherPage(latitude: 50,longitude: 50).weatherBanner(context),
          ),
          Container(
            color: Color.fromARGB(255, 161, 255, 210),
            width: screenWidth,
            height: 40,
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: const Text(
                "Safe, low chance of raining: 26%",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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