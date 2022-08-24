import 'package:flutter/material.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/category_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../services/utils.dart';

class SideNavigator extends StatefulWidget {
  SideNavigator({
    Key? key,
    required this.onPress,
    required this.categories,
  }) : super(key: key);

  Function(int) onPress;
  List<Category> categories;

  @override
  State<SideNavigator> createState() => _SideNavigatorState();
}

class _SideNavigatorState extends State<SideNavigator> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final categories = Provider.of<CategoryProvider>(context).categories;
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return SizedBox(
      height: size.height -
          (kToolbarHeight +
              kBottomNavigationBarHeight +
              kTextTabBarHeight), // kToolbarHeight / kBottomNavigationBarHeight / kTextTabBarHeight provided by flutter
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) => GestureDetector(
          onTap: () => widget.onPress(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 100,
            color: isDarkTheme && !widget.categories[index].isSelected!
                ? const Color(0xFF758699)
                : !isDarkTheme && !widget.categories[index].isSelected!
                    ? const Color(0xFFdae3e3)
                    : isDarkTheme && widget.categories[index].isSelected!
                        ? const Color(0xFF1c2732)
                        : const Color(0xFFf9f7f7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(widget.items[index].icon),
                  Text(
                    isArabic
                        ? categories[index].arName.toString()
                        : categories[index].enName.toString(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
