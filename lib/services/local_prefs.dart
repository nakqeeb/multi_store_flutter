import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefs {
  static const LOCAL_CODE = "LOCALCODE";

  setLocal(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LOCAL_CODE, value);
  }

  Future<String> getLocal() async {
    // this will get system language
    final localeLangCode = Platform.localeName;
    final defaultLocale = localeLangCode.substring(
        0, localeLangCode.indexOf('_')); // to cut the country code Ex 'en_US'
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(LOCAL_CODE) ?? defaultLocale;
    // return prefs.getString(LOCAL_CODE) ?? 'en';
  }
}
