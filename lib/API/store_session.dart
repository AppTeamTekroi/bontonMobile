import 'package:shared_preferences/shared_preferences.dart';

class StoreSession {
  static Future<String> stockWhs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_code') ?? '';
  }

  static Future<int> userId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }
}
