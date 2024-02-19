import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Future<String> getLocation(double latitude, double longitude) async {
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
}
