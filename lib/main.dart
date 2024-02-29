import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geotask/firebase_options.dart';
import 'package:geotask/page/home_page.dart';
import 'package:geotask/page/register_page.dart';
import 'package:geotask/page/start_page.dart';
import 'package:geotask/page/weather_page.dart';
import 'package:geotask/provider/todo_provider.dart';
import 'package:provider/provider.dart';
import './page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
          title: 'GeoTask',
          home: StartPage(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF70AAA7)),
            textTheme: Typography.blackHelsinki,
            useMaterial3: true,
          )),
    );
  }
}
