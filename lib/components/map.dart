import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StreetMap extends StatelessWidget {
  final List<LatLng> points;
  final double offsetFactor;

  StreetMap({
    super.key,
    // this.points = const [
    //   LatLng(51.5, -0.09),
    //   LatLng(50, 12),
    //   LatLng(51.5, -0.13),
    // ],
    this.points = const [],
    this.offsetFactor = 0,
  });

  @override
  Widget build(BuildContext context) {
    var centralPoint = LatLng(13.74, 100.46);
    var zoom = 10.0;

    if (points.isNotEmpty) {
      var pointsSum = [0.0, 0.0];

      var border = {
        "minLat": points[0].latitude,
        "maxLat": points[0].latitude,
        "minLong": points[0].longitude,
        "maxLong": points[0].longitude
      };

      for (var point in points) {
        pointsSum = [
          pointsSum[0] + point.latitude,
          pointsSum[1] + point.longitude
        ];
        if (point.latitude < border["minLat"]!) {
          border["minLat"] = point.latitude;
        }
        if (point.latitude > border["maxLat"]!) {
          border["maxLat"] = point.latitude;
        }
        if (point.longitude < border["minLong"]!) {
          border["minLong"] = point.longitude;
        }
        if (point.longitude > border["maxLong"]!) {
          border["maxLong"] = point.longitude;
        }
      }

      // calculate the central point and zoom using some math
      centralPoint =
          LatLng(pointsSum[0] / points.length, pointsSum[1] / points.length);
      var maxDistance = max(border["maxLat"]! - border["minLat"]!,
          border["maxLong"]! - border["minLong"]!);
      zoom = log(180 / maxDistance) / log(2) + 1;
    }

    // 50% offset because some stuff blocking the way
    var mapHeight = 180 * offsetFactor / (2 * pow(2, zoom - 2));
    centralPoint =
        LatLng(centralPoint.latitude - mapHeight, centralPoint.longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: centralPoint,
        initialZoom: zoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
            markers: points.map((point) {
          return Marker(
            width: 40.0,
            height: 40.0,
            point: point,
            child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
          );
        }).toList()),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0)
              )
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 90.0),
              child: TextSourceAttribution("OpenStreetMap contributors",
                  onTap: () => launchUrl(
                      Uri.parse("https://www.openstreetmap.org/copyright"))),
            ),
          ),
        )
      ],
    );
  }
}

class MarkerLayerBuilder extends StatelessWidget {
  final List<LatLng> markers;

  MarkerLayerBuilder({super.key, this.markers = const []});

  @override
  Widget build(BuildContext context) {
    if (markers.isEmpty) {
      return MarkerLayer(markers: []);
    }

    var border = {
      "minLat": markers[0].latitude,
      "maxLat": markers[0].latitude,
      "minLong": markers[0].longitude,
      "maxLong": markers[0].longitude
    };

    // need to use array because LatLng will thrown error if the number is above 90
    var pointsSum = [0.0, 0.0];
    for (var point in markers) {
      pointsSum = [
        pointsSum[0] + point.latitude,
        pointsSum[1] + point.longitude
      ];
      if (point.latitude < border["minLat"]!) {
        border["minLat"] = point.latitude;
      }
      if (point.latitude > border["maxLat"]!) {
        border["maxLat"] = point.latitude;
      }
      if (point.longitude < border["minLong"]!) {
        border["minLong"] = point.longitude;
      }
      if (point.longitude > border["maxLong"]!) {
        border["maxLong"] = point.longitude;
      }
    }

    var centralPoint =
        LatLng(pointsSum[0] / markers.length, pointsSum[1] / markers.length);
    var maxDistance = max(border["maxLat"]! - border["minLat"]!,
        border["maxLong"]! - border["minLong"]!);
    var zoom = log(180 / maxDistance) / log(2) + 1;

    return MarkerLayer(
        markers: markers.map((point) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: point,
        child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
      );
    }).toList());
  }
}
