import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geotask/firebase_options.dart';
import 'package:geotask/page/start_page.dart';
import 'package:geotask/provider/user_provider.dart';

import 'package:geotask/provider/todo_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize shared_preferences as static data to store the username
  await User.init(); 

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
