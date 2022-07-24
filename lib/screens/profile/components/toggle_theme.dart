import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class ToggleTheme extends StatefulWidget {
  const ToggleTheme({super.key});

  @override
  State<ToggleTheme> createState() => _ToggleThemeState();
}

class _ToggleThemeState extends State<ToggleTheme> {
  @override
  Widget build(BuildContext context) {
    var themeState = Provider.of<DarkThemeProvider>(context);
    var _isDarkTheme = themeState.isDarkTheme;
    return SwitchListTile(
      value: _isDarkTheme,
      activeColor: const Color(0xFF1d1629),
      title: Text(
        _isDarkTheme ? 'Dark mode' : 'Light mode',
      ),
      secondary: Icon(
          _isDarkTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
      onChanged: (bool value) {
        setState(() {
          themeState.setDarkTheme = value;
        });
      },
    );
  }
}
