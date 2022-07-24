import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDarkTheme ? const Color(0xFF1d1629) : const Color(0xFFf5b46e),
      ),
      scaffoldBackgroundColor:
          //0A1931  // white yellow 0xFFFCF8EC
          isDarkTheme ? const Color(0xFF1d1629) : const Color(0xFFf5b46e),
      primaryColor: const Color(0xFF7e906f),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary:
                isDarkTheme ? const Color(0xFF4d3a6b) : const Color(0xFFfbe6ce),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor:
          isDarkTheme ? const Color(0xFF4d3a6b) : const Color(0xFFfbe6ce),
      canvasColor:
          isDarkTheme ? const Color(0xFF4d3a6b) : const Color(0xFFfbe6ce),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      textTheme: TextTheme(
        bodyText1: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFfbe6ce)
                : const Color(0xFF4d3a6b)),
        bodyText2: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFfbe6ce)
                : const Color(0xFF4d3a6b)),
        headline6: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFfbe6ce)
                : const Color(0xFF4d3a6b)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            isDarkTheme ? const Color(0xFF1d1629) : const Color(0xFFf5b46e),
        selectedItemColor:
            isDarkTheme ? const Color(0xFFf5b46e) : const Color(0xFF1d1629),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor:
            isDarkTheme ? const Color(0xFFf5b46e) : const Color(0xFF4d3a6b),
        unselectedLabelColor:
            isDarkTheme ? const Color(0xFFfbe6ce) : const Color(0xFF9a8ca6),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              color: isDarkTheme
                  ? const Color(0xFFf5b46e)
                  : const Color(0xFF4d3a6b),
              width: 8.0),
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? const Color(0xFFfbe6ce) : const Color(0xFF4d3a6b),
      ),
      cardTheme: CardTheme(
          shadowColor:
              isDarkTheme ? const Color(0xFFfbe6ce) : const Color(0xFF4d3a6b),
          elevation: 15),
    );
  }

  /* static CupertinoThemeData cupertinoThemeData(bool isDarkTheme) {
    return CupertinoThemeData(
      primaryColor:
          isDarkTheme ? const Color(0xFFfbe6ce) : const Color(0xFF4d3a6b),
      /* textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
            color: isDarkTheme
                ? const Color(0xFFfbe6ce)
                : const Color(0xFF4d3a6b)),
      ), */
    );
  } */
}
