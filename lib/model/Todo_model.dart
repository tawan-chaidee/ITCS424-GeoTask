import 'package:flutter/foundation.dart';

class Todo {
  final String title;
  final String subtitle;
  final String startTime;
  final String endTime;
  final String details;

  Todo({
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.details,
  });
}
