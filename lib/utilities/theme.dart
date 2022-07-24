import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7),
      ),
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary:
                isDarkTheme ? const Color(0xFF758699) : const Color(0xFFD6EAF8),
            secondary:
                isDarkTheme ? const Color(0xFFD6EAF8) : const Color(0xFF758699),
            tertiary: isDarkTheme
                ? const Color(0xFF53412e)
                : const Color(0xFF7e6e5d), //used in Auth annd prodDetails scree
            inversePrimary: isDarkTheme
                ? const Color(0xFF5faee3)
                : const Color(0xFF217dbb), //used in Auth annd prodDetails scree
            surface:
                isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor:
          isDarkTheme ? const Color(0xFF758699) : const Color(0xFFdae3e3),
      canvasColor:
          isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light(),
          ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFdae3e3)
                : const Color(0xFF758699)),
        bodyText2: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFdae3e3)
                : const Color(0xFF758699)),
        headline6: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFdae3e3)
                : const Color(0xFF758699)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7),
        selectedItemColor:
            isDarkTheme ? const Color(0xFFf9f7f7) : const Color(0xFF1c2732),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor:
            isDarkTheme ? const Color(0xFFD6EAF8) : const Color(0xFF475461),
        unselectedLabelColor:
            isDarkTheme ? const Color(0xFFaad4f1) : const Color(0xFF758699),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              color: isDarkTheme
                  ? const Color(0xFFf9f7f7)
                  : const Color(0xFF758699),
              width: 8.0),
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
      ),
      cardTheme: CardTheme(
        shadowColor:
            isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
        elevation: 10,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isDarkTheme ? const Color(0xFFD6EAF8) : const Color(0xFF758699),
      ),
    );
  }

  /* static CupertinoThemeData cupertinoThemeData(bool isDarkTheme) {
    return CupertinoThemeData(
      primaryColor:
          isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
      /* textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFdae3e3)
                : const Color(0xFF758699)),
      ), */
    );
  } */
}
