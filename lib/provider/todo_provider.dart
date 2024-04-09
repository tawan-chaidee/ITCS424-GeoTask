import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:latlong2/latlong.dart';

//Weather provider todo later
class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

  TodoProvider() {
    _getFireBaseData();
    // _generateMockData(); // initiate with mock data
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Object?> querySnapshot =
          await FirebaseFirestore.instance.collection('Todo').get();
      print(querySnapshot.docs[0]["title"]);
      _todoList.clear();

      querySnapshot.docs.forEach((doc) {
        Todo todo = Todo(
          title: doc['title'],
          subtitle: doc['subtitle'],
          startTime: doc['startTime'].toDate(),
          endTime: doc['endTime'].toDate(),
          details: doc['details'],
          locationName: doc['locationName'],
          Id: doc['Id'],

          //TODO
          //locationLatLng: stringToLatLng(doc['locationLatLng']),
          locationLatLng: LatLng(50, 50),
          isDone: doc['isDone'] ?? false,
        );

        _todoList.add(todo);
      });

      // Notify listeners to rebuild UI
      notifyListeners();
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }
  }

  Future<bool> deleteTodo(String id) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Delete the todo from Firestore
      int index = _todoList.indexWhere((todo) => todo.Id == id);

      if (index != -1) {
        await _firestore.collection('Todo').doc(id).delete();

        _todoList.removeAt(index);
        notifyListeners();

        return true;
      } else {
        print('Todo not found with id: $id');
        return false;
      }
    } catch (error) {
      print('Error deleting todo: $error');
      return false;
    }
  }

  void addTodo(Todo todo) {
    _todoList.add(todo);
    notifyListeners();
  }

  void _getFireBaseData() {
    dynamic data = fetchDataFromFirebase();
    print(data);
  }

  Future<void> _generateMockData() async {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var tomorrow = today.add(Duration(days: 1));

    _todoList = [
      Todo(
        Id: '1',
        title: 'Outdoor Team Building',
        subtitle: 'Engage in team-building activities in the park',
        startTime: today.add(Duration(hours: 9)),
        endTime: today.add(Duration(hours: 10, minutes: 30)),
        details:
            '• Plan and participate in outdoor team-building activities in the nearby park.\n\n• Conduct icebreaker games and teamwork exercises.\n\n• Build a positive team culture and strengthen team bonds.',
      ),
      Todo(
        Id: '2',
        title: 'Outdoor Soccer Match',
        subtitle: 'Enjoy a friendly soccer match',
        startTime: today.add(Duration(hours: 11)),
        endTime: today.add(Duration(hours: 12, minutes: 30)),
        locationName: "Mahidol Soccer Field",
        locationLatLng: LatLng(13.797585618643012, 100.31856763604735),
        details:
            '• Organize and participate in a friendly soccer match outdoors, weather permitting.\n\n• Form teams, play a spirited game, and have fun on the field.\n\n• Note: In case of adverse weather conditions, consider rescheduling or choosing an alternative indoor activity.',
      ),
      Todo(
        Id: '3',
        title: 'Lunch Break',
        subtitle: 'Take a break and recharge',
        startTime: today.add(Duration(hours: 13)),
        endTime: today.add(Duration(hours: 14)),
        details:
            'Enjoy a healthy lunch and take a short break to relax.\n\nConsider going for a walk or doing a quick mindfulness exercise to recharge for the afternoon tasks.\n\nAvoid heavy meals that may cause sluggishness.\n\nUse this time to catch up with colleagues and build a positive team culture.',
      ),
      Todo(
        Id: '4',
        title: 'Project Planning',
        subtitle: 'Create project roadmap and timeline',
        startTime: today.add(Duration(hours: 14, minutes: 30)),
        endTime: today.add(Duration(hours: 16)),
        details:
            '• Meet with the project management team to discuss and plan upcoming milestones.\n\n• Create a detailed project roadmap, allocate resources, and set realistic timelines for each phase of the project.\n\n• Identify potential risks and mitigation strategies.\n\n• Communicate the plan to the entire team and gather input for improvement.',
      ),
      Todo(
          Id: '5',
          title: 'Project Planning',
          subtitle: 'Create project roadmap and timeline',
          startTime: tomorrow.add(Duration(hours: 14, minutes: 30)),
          endTime: tomorrow.add(Duration(hours: 16)),
          locationName: "ICT Mahidol",
          locationLatLng: LatLng(13.794516750087157, 100.32470839628395)),
      Todo(
        Id: '6',
        title: 'Tomorrow Lunch Break',
        subtitle: 'Take a break and recharge at the park',
        startTime: tomorrow.add(Duration(hours: 13)),
        endTime: tomorrow.add(Duration(hours: 14)),
        locationName: "The Park",
        locationLatLng: LatLng(13.791427313867672, 100.31966008693307),
        details:
            'Enjoy a healthy lunch and take a short break to relax.\n\nConsider going for a walk or doing a quick mindfulness exercise to recharge for the afternoon tasks.\n\nAvoid heavy meals that may cause sluggishness.\n\nUse this time to catch up with colleagues and build a positive team culture.',
      ),
    ];

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    for (var todo in _todoList) {
      try {
        await _firestore.collection('Todo').doc(todo.Id).set(todo.toMap());
        print('Todo added successfully: ${todo.title}');
      } catch (error) {
        print('Error adding todo: $error');
      }
    }
  }

  String _generateId(String title, DateTime timestamp) {
    String formattedTimestamp = timestamp.microsecondsSinceEpoch.toString();
    return '$title-$formattedTimestamp';
  }

  Map<DateTime, List<Todo>> getCategorizedTodoList(
      DateTime? start, DateTime? end) {
    var filteredTodo = _todoList.where((todo) {
      var startDate =
          start == null ? DateTime(start!.year, start.month, start.day) : null;
      var endDate =
          end == null ? DateTime(end!.year, end.month, end.day) : null;

      return (startDate == null || todo.startTime.isAfter(startDate)) &&
          (endDate == null || todo.startTime.isBefore(endDate));
    }).toList();

    var categorizedTodo = <DateTime, List<Todo>>{};
    for (var todo in filteredTodo) {
      // use key as day, month, and day with time set to 00:00:00
      var date = DateTime(
          todo.startTime.year, todo.startTime.month, todo.startTime.day);

      if (categorizedTodo.containsKey(date)) {
        categorizedTodo[date]!.add(todo);
      } else {
        categorizedTodo[date] = [todo];
      }
    }

    categorizedTodo.forEach((key, value) {
      value.sort((a, b) => a.startTime.compareTo(b.startTime));
    });

    // print(categorizedTodo);
    return categorizedTodo;
  }

  List<LatLng> getLocations(DateTime? start, DateTime? end) {
    var filteredTodo = _todoList.where((todo) {
      var startDate =
          start == null ? DateTime(start!.year, start.month, start.day) : null;
      var endDate =
          end == null ? DateTime(end!.year, end.month, end.day) : null;

      return (startDate == null || todo.startTime.isAfter(startDate)) &&
          (endDate == null || todo.startTime.isBefore(endDate));
    }).toList();

    var locations = <LatLng>[];
    for (var todo in filteredTodo) {
      if (todo.locationLatLng != null) {
        locations.add(todo.locationLatLng!);
      }
    }

    return locations;
  }

  void editTodo(int index, Todo todo) {
    _todoList[index] = todo;
    notifyListeners();
  }
}
