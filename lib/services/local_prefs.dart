import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefs {
  static const LOCAL_CODE = "LOCALCODE";

  setLocal(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LOCAL_CODE, value);
  }

  Future<String> getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOCAL_CODE) ?? 'en';
  }
}
