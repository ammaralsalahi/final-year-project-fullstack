import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(int id) async {
    await _prefs?.setInt('user_id', id);
  }

  static int? getUserId() {
    return _prefs?.getInt('user_id');
  }
}
