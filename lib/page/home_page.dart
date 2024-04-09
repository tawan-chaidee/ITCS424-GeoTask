import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask/components/date.dart';
import 'package:geotask/components/task.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:geotask/provider/todo_provider.dart';
import 'package:geotask/components/bottom_sheet.dart' as componentBottomSheet;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geotask/page/add_page.dart';

import '../components/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _incrementCounter() {
    print("increment");
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _incrementCounter();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<TodoProvider>(builder: (context, provider, _) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPage(),
              ),
            );
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        );
      }),
      body: Stack(
        children: [
          Consumer<TodoProvider>(builder: (context, tasksModel, child) {
            return StreetMap(
              offsetFactor: 0.5,
              points: tasksModel.getLocations(
                  DateTime.now(), DateTime.now().add(const Duration(days: 1))),
            );
          }),
          SafeArea(
            child: componentBottomSheet.BottomSheet(
              child: Consumer<TodoProvider>(builder: (context, tasksModel, child) {
                var tasks = tasksModel.getCategorizedTodoList(
                    DateTime.now(), DateTime.now().add(const Duration(days: 1)));

                return ListView.builder(
                  itemCount: tasks.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == tasks.length) {
                      return Container(
                        height: 80,
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateHeader(tasks.keys.elementAt(index)),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tasks.values.elementAt(index).length,
                            itemBuilder: (BuildContext context, int index2) {
                              return TaskTile(
                                task: tasks.values.elementAt(index)[index2],
                                taskDate: tasks.keys.elementAt(index),
                                taskIndex: index2,
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
