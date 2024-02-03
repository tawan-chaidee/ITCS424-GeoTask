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
      WeatherPage()
    );

    
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Flutter Page'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           'Hello, Flutter!',
    //           style: TextStyle(fontSize: 24),
    //         ),
    //         SizedBox(height: 20),
    //         ElevatedButton(
    //           onPressed: () {
    //             // Navigate to the SecondPage when the button is pressed
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => SecondPage()),
    //             );
    //           },
    //           child: Text('Go to Second Page'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
