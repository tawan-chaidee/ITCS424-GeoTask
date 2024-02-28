import 'package:flutter/material.dart';
import 'package:geotask/page/login_page.dart';
import 'package:geotask/page/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoTask'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100.0, bottom: 300.0),
            child: const Center(
              child: Text(
                'GeoTask',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18.0),
              fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 20.0),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18.0),
              fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 20.0),
            ),
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}
