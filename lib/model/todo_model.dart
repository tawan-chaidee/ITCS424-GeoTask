
class Todo {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final String? details;
  final String? location;
  final bool isDone;

  Todo({
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    this.details,
    this.location,
    this.isDone = false,
  });
}