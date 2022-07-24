import 'package:flutter/material.dart';

import '../services/dark_theme_prefs.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePrefs darkThemePrefs = DarkThemePrefs();
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  set setDarkTheme(bool value) {
    _isDarkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();
  }
}
