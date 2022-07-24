import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/app_bar_title.dart';
import '../../providers/dark_theme_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    return Material(
      color:
          isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7), // n
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: const AppBarBackButton(),
            title: const AppBarTitle(title: 'Wishlist'),
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
