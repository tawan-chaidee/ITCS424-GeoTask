import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './page/main_page.dart';
import './provider/todo_provider';
import './page/todo_detail_page.dart';
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
        home: MainPage(),
      ),
    );
  }
}
