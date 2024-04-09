import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:latlong2/latlong.dart';

//Weather provider todo later
class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

  TodoProvider() {
    // initiate with mock data
    // _generateMockData();

    _getFireBaseData();
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
          id: doc['id'],

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
      int index = _todoList.indexWhere((todo) => todo.id == id);

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
        title: 'Outdoor Soccer Match',
        subtitle: 'Enjoy a friendly soccer match',
        startTime: DateTime.now().add(Duration(hours: 1)),
        endTime: DateTime.now().add(Duration(hours: 2)),
        id: '1',
        locationName: 'Local Soccer Field',
        details: 'Invite colleagues for a friendly game of soccer.',
        locationLatLng: LatLng(37.7749, -122.4194), // San Francisco coordinates
      ),
      Todo(
        title: 'Morning Jog',
        subtitle: 'Get some exercise with a morning jog',
        startTime: DateTime.now().add(Duration(hours: 3)),
        endTime: DateTime.now().add(Duration(hours: 4)),
        id: '2',
        locationName: 'Park',
        details: 'Start your day with a refreshing jog in the park.',
        locationLatLng: LatLng(40.7128, -74.0060), // New York coordinates
      ),
      Todo(
        title: 'Outdoor Basketball Game',
        subtitle: 'Shoot some hoops with friends',
        startTime: DateTime.now().add(Duration(hours: 5)),
        endTime: DateTime.now().add(Duration(hours: 6)),
        id: '3',
        locationName: 'Local Basketball Court',
        details: 'Gather friends for a casual game of basketball outdoors.',
        locationLatLng: LatLng(34.0522, -118.2437), // Los Angeles coordinates
      ),
      Todo(
        title: 'Weekend Hike',
        subtitle: 'Explore nature with a weekend hike',
        startTime: DateTime.now().add(Duration(hours: 7)),
        endTime: DateTime.now().add(Duration(hours: 8)),
        id: '4',
        locationName: 'Nature Reserve',
        details: 'Plan a hike with colleagues to enjoy the outdoors.',
        locationLatLng: LatLng(47.6062, -122.3321), // Seattle coordinates
      ),
      Todo(
        title: 'Team Lunch',
        subtitle: 'Enjoy a team lunch together',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 12, 0), // Set lunchtime to 12:00 PM
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 13, 0), // End lunchtime at 1:00 PM
        id: '5',
        locationName: 'Local Restaurant',
        details: 'Gather the team for a lunch outing to bond and relax.',
        locationLatLng: LatLng(37.7749, -122.4194), // San Francisco coordinates
      ),
      Todo(
        title: 'Project Meeting',
        subtitle: 'Discuss project updates and plans',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 0), // Set meeting time to 2:00 PM
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 15, 0), // End meeting at 3:00 PM
        id: '6',
        locationName: 'Office Conference Room',
        details:
            'Conduct a meeting to review project progress and discuss upcoming tasks.',
        locationLatLng: LatLng(37.7749, -122.4194), // San Francisco coordinates
      ),
    ];

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    for (var i = 0; i < _todoList.length; i++) {
      print(i);
      var todo = _todoList[i];
      try {
        await Future.delayed(Duration(seconds: i), () async {
          await _firestore.collection('Todo').doc(todo.id).set(todo.toMap());
          print('Todo added successfully: ${todo.title}');
        });
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
