import 'package:flutter/material.dart';
import '../model/todo_model.dart';

//Weather provider todo later
class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

  TodoProvider() {
    // start with some mock data
    _generateMockData();
  }

  void addTodo(Todo todo) {
    _todoList.add(todo);
    notifyListeners();
  }

  void _generateMockData() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var tomorrow = today.add(Duration(days: 1));

    _todoList = [
      Todo(
        title: 'Outdoor Team Building',
        subtitle: 'Engage in team-building activities in the park',
        startTime: today.add(Duration(hours: 9)),
        endTime: today.add(Duration(hours: 10, minutes: 30)),
        details:
            '• Plan and participate in outdoor team-building activities in the nearby park.\n\n• Conduct icebreaker games and teamwork exercises.\n\n• Build a positive team culture and strengthen team bonds.',
      ),
      Todo(
        title: 'Outdoor Soccer Match',
        subtitle: 'Enjoy a friendly soccer match',
        startTime: today.add(Duration(hours: 11)),
        endTime: today.add(Duration(hours: 12, minutes: 30)),
        location: "Mahidol Soccer Field",
        details:
            '• Organize and participate in a friendly soccer match outdoors, weather permitting.\n\n• Form teams, play a spirited game, and have fun on the field.\n\n• Note: In case of adverse weather conditions, consider rescheduling or choosing an alternative indoor activity.',
      ),
      Todo(
        title: 'Lunch Break',
        subtitle: 'Take a break and recharge',
        startTime: today.add(Duration(hours: 13)),
        endTime: today.add(Duration(hours: 14)),
        details:
            'Enjoy a healthy lunch and take a short break to relax.\n\nConsider going for a walk or doing a quick mindfulness exercise to recharge for the afternoon tasks.\n\nAvoid heavy meals that may cause sluggishness.\n\nUse this time to catch up with colleagues and build a positive team culture.',
      ),
      Todo(
        title: 'Project Planning',
        subtitle: 'Create project roadmap and timeline',
        startTime: today.add(Duration(hours: 14, minutes: 30)),
        endTime: today.add(Duration(hours: 16)),
        details:
            '• Meet with the project management team to discuss and plan upcoming milestones.\n\n• Create a detailed project roadmap, allocate resources, and set realistic timelines for each phase of the project.\n\n• Identify potential risks and mitigation strategies.\n\n• Communicate the plan to the entire team and gather input for improvement.',
      ),
      Todo(
        title: 'Project Planning',
        subtitle: 'Create project roadmap and timeline',
        startTime: tomorrow.add(Duration(hours: 14, minutes: 30)),
        endTime: tomorrow.add(Duration(hours: 16)),
      ),
      Todo(
        title: 'Tomorrow Lunch Break',
        subtitle: 'Take a break and recharge at the park',
        startTime: tomorrow.add(Duration(hours: 13)),
        endTime: tomorrow.add(Duration(hours: 14)),
        location: "The Park",
        details:
            'Enjoy a healthy lunch and take a short break to relax.\n\nConsider going for a walk or doing a quick mindfulness exercise to recharge for the afternoon tasks.\n\nAvoid heavy meals that may cause sluggishness.\n\nUse this time to catch up with colleagues and build a positive team culture.',
      ),
    ];
    notifyListeners();
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
}