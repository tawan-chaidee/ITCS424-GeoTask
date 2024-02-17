import 'package:geocoding/geocoding.dart';

//Get city name from latitute and longtitute
class GeocodingService {
  Future<String> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        String cityName = placemarks[0].locality ?? "";
        return cityName;
      } else {
        return "City not found";
      }
    } catch (e) {
      print("Error getting city name: $e");
      return "Error";
    }
  }
}
