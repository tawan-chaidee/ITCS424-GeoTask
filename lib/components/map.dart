import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StreetMap extends StatefulWidget {
  final List<LatLng> points;
  final double offsetFactor;
  final double bottomPadding;

  StreetMap({
    super.key,
    this.points = const [],
    this.offsetFactor = 0,
    this.bottomPadding = 0,
  });

  @override
  State<StreetMap> createState() => _StreetMapState();
}

class _StreetMapState extends State<StreetMap> {
  MapController? mapController;

  @override
  Widget build(BuildContext context) {
    // default data
    var centralPoint = const LatLng(13.74, 100.46);
    LatLngBounds? bounds;
    var zoom = 10.0;

    // for one point
    if (widget.points.length == 1) {
      centralPoint = widget.points[0];
      zoom = 14.0;

      // 50% offset because some stuff blocking the way
      var mapHeight = 180 * widget.offsetFactor / (2 * pow(2, zoom - 2));
      centralPoint = LatLng(centralPoint.latitude - mapHeight, centralPoint.longitude);
    }

    // for two+ points
    if (widget.points.length > 1) {
      var border = {
        "minLat": widget.points[0].latitude,
        "maxLat": widget.points[0].latitude,
        "minLong": widget.points[0].longitude,
        "maxLong": widget.points[0].longitude
      };

      for (var point in widget.points) {
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

     centralPoint = LatLng(
          (border["maxLat"]! + border["minLat"]!) / 2,
          (border["maxLong"]! + border["minLong"]!) / 2
      );
      var maxDistance = max(
          border["maxLat"]! - border["minLat"]!, border["maxLong"]! - border["minLong"]!);
      zoom = log(360 / maxDistance) / log(2) + 2;

      // 50% offset because some stuff blocking the way
      var mapHeight = 180 * widget.offsetFactor / (2 * pow(2, zoom - 2));
      centralPoint =
          LatLng(centralPoint.latitude - mapHeight, centralPoint.longitude);
    }

    // create map controller if not exists, move if exists
    if (mapController == null) {
      mapController = MapController();
    } else {
      mapController!.move(centralPoint, zoom);
    }

    return FlutterMap(
      mapController: mapController,
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
            alignment: Alignment.topCenter,
            markers: widget.points.map((point) {
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
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(10.0))),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: widget.bottomPadding),
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
