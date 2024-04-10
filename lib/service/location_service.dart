import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressData {
  final String? city;
  final String? state;
  final String? country;

  AddressData({
    required this.city,
    required this.state,
    required this.country,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

}

class LocationData {
  final double lat;
  final double lon;
  final String? name;
  final String? displayName;
  final AddressData? address;

  LocationData({
    required this.lat,
    required this.lon,
    this.name,
    this.displayName,
    this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      name: json['name'],
      displayName: json['display_name'],
      address: AddressData.fromJson(json['address']),
    );
  }
}

class LocationService {
  Future<String> getCity(double latitude, double longitude) async {
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latitude}&lon=${longitude}&zoom=10';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city = data['address']['state'] ??
            data['address']['city'] ??
            data['address']['county'];
        return city ?? 'Location not found';
      } else {
        return 'Location not found';
      }
    } catch (e) {
      print('Error getting location: $e');
      return 'Error';
    }
  }

  Future<LocationData> getLocation(double latitude, double longitude) async {
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latitude}&lon=${longitude}&zoom=18';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LocationData.fromJson(data);
      } else {
        return LocationData(
          lat: latitude,
          lon: longitude,
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      return LocationData(
        lat: latitude,
        lon: longitude,
      );
    }
  }
}
