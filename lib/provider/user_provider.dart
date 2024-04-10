import 'package:shared_preferences/shared_preferences.dart';

class User {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static void setUserId(String userId) {
    _preferences?.setString('userId', userId);
  }

  static String getUserId() {
    return _preferences?.getString('userId') ?? '';
  }
}
