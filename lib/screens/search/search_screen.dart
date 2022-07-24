import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:provider/provider.dart';
import '../../providers/dark_theme_provider.dart';
import './components/body.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
        title: CupertinoSearchTextField(
          style: TextStyle(
            color:
                isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
