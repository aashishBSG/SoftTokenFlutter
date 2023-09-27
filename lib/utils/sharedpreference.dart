import 'package:shared_preferences/shared_preferences.dart';

class UtilSharedPreferences {
  static Future<String> getVersionCode() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('access_VersionCode') ?? '';
  }

  static Future<void> setVersionCode(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('access_VersionCode', value);
  }

  Future<String> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('access_token') ?? '';
  }

  static Future<void> setToken(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('access_token', value);
  }

  static Future<String> getUserID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('access_UserID') ?? '';
  }

  static Future setUserID(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('access_UserID', value);
  }
}
