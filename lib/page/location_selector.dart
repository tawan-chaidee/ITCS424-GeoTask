import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask/components/map.dart';
import 'package:geotask/service/location_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class LocationSelectorPage extends StatefulWidget {
  @override
  _LocationSelectorPageState createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> {
  MapController mapController = MapController();
  LatLng currentPosition = LatLng(13.74, 100.46);
  String locationName = "Unknown";

  Future<dynamic> fetchLocationName(LatLng position) async {
    // Fetch location name from the internet
    var uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&limit=1&lat=${position.latitude}&lon=${position.longitude}&zoom=18');

    var res = await http.get(uri, headers: {
      'User-Agent':
          'Mozilla/5.0 (compatible; MSIE 11.0; Windows; U; Windows NT 10.2; WOW64; en-US Trident/7.0)',
    });
    var json = await jsonDecode(res.body);

    print(json['address']);

    return json;
  }

  List<String> splitLocationName(String locationName) {
    var split = locationName.split(",");
    if (split.length < 2) {
      return [split[0], ""];
    }
    if (split.length == 2) {
      return split;
    }
    return [split.sublist(0, 2).join(", "), split.sublist(2).join(", ")];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Location'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, [currentPosition, splitLocationName(locationName)[0]]);
          },
          child: Icon(Icons.check),
        ),
        body: Stack(
          children: [
            FlutterMap(
                options: MapOptions(
                    initialCenter: LatLng(13.74, 100.46),
                    initialZoom: 12,
                    onTap: (tapPosition, point) async {
                      setState(() {
                        currentPosition = point;
                      });
                      var locname = await LocationService().getLocation(point.latitude, point.longitude);
                      print(locname.displayName);
                      setState(()  {
                        locationName = locname.displayName ?? "Unknown";
                      });
                    }),
                mapController: mapController,
                children: [
                  Listener(
                    onPointerUp: (event) {
                      // print(mapController.camera.center);
                    },
                    child: Stack(
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          alignment: Alignment.topCenter,
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: currentPosition,
                              // alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(splitLocationName(locationName)[0],
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(splitLocationName(locationName)[1],
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Text(
                        "Latitute/Longitude: ${currentPosition.latitude.toStringAsFixed(6)}, ${currentPosition.longitude.toStringAsFixed(6)}",
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
