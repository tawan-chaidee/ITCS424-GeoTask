import 'package:latlong2/latlong.dart';

class Todo {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final String? details;
  final String? locationName;
  final LatLng? locationLatLng;
  final bool isDone;

  Todo({
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    this.details,
    this.locationName,
    this.locationLatLng,
    this.isDone = false,
  });
}