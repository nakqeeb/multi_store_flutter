import 'package:flutter/material.dart';
import 'package:multi_store_app/services/local_prefs.dart';

import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  LocalPrefs localPrefs = LocalPrefs();

  bool get isArabic => _locale == const Locale('ar');

  Locale? get locale => _locale;

  set setLocal(String value) {
    _locale = Locale(value);
    localPrefs.setLocal(value);
    notifyListeners();
  }

  void setLanguage(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
