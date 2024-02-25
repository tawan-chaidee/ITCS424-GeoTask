import 'package:flutter/material.dart';
import '../model/Todo_model.dart';

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
    _todoList = [
      Todo(
        title: 'Outdoor Team Building',
        subtitle: 'Engage in team-building activities in the park',
        startTime: '9:00 AM',
        endTime: '10:30 AM',
        details:
            '• Plan and participate in outdoor team-building activities in the nearby park.\n\n• Conduct icebreaker games and teamwork exercises.\n\n• Build a positive team culture and strengthen team bonds.',
      ),
      Todo(
        title: 'Outdoor Soccer Match',
        subtitle: 'Enjoy a friendly soccer match',
        startTime: '11:00 AM',
        endTime: '12:30 PM',
        details:
            '• Organize and participate in a friendly soccer match outdoors, weather permitting.\n\n• Form teams, play a spirited game, and have fun on the field.\n\n• Note: In case of adverse weather conditions, consider rescheduling or choosing an alternative indoor activity.',
      ),
      Todo(
        title: 'Lunch Break',
        subtitle: 'Take a break and recharge',
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        details:
            'Enjoy a healthy lunch and take a short break to relax.\n\nConsider going for a walk or doing a quick mindfulness exercise to recharge for the afternoon tasks.\n\nAvoid heavy meals that may cause sluggishness.\n\nUse this time to catch up with colleagues and build a positive team culture.',
      ),
      Todo(
        title: 'Project Planning',
        subtitle: 'Create project roadmap and timeline',
        startTime: '2:30 PM',
        endTime: '4:00 PM',
        details:
            '• Meet with the project management team to discuss and plan upcoming milestones.\n\n• Create a detailed project roadmap, allocate resources, and set realistic timelines for each phase of the project.\n\n• Identify potential risks and mitigation strategies.\n\n• Communicate the plan to the entire team and gather input for improvement.',
      ),
    ];
    notifyListeners();
  }
}
