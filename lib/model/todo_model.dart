import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Todo {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final String? details;
  final String? locationName;
  final LatLng? locationLatLng;
  final String? id;
  final bool isDone;

  Todo({
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.id,
    this.details,
    this.locationName,
    this.locationLatLng,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'startTime': startTime,
      'endTime': endTime,
      'details': details,
      'locationName': locationName,
      'locationLatLng': locationLatLng != null
          ? GeoPoint(locationLatLng!.latitude, locationLatLng!.longitude)
          : null,
      'isDone': isDone,
      'id': id,
    };
  }
}
