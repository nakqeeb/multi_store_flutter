import 'package:flutter/material.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/screens/category/components/category_page_view.dart';
import 'package:provider/provider.dart';

import '../../../providers/category_provider.dart';
import '../../../providers/dark_theme_provider.dart';
import '../../../services/utils.dart';

class CategoryView extends StatefulWidget {
  CategoryView(
      {Key? key,
      required this.onPageChange,
      required this.categories,
      required this.pageController})
      : super(key: key);

  Function(int) onPageChange;
  List<Category> categories;

  PageController pageController;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final List<Widget> _pages = [];

  List<Widget> _pageMaker() {
    _pages.clear();
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    for (var i = 0; i < categories.length; i++) {
      _pages.add(CategoryPageView(
        category: categories[i],
      ));
    }
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final size = Utils(context).getScreenSize;
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7),
      child: PageView(
        controller: widget.pageController,
        onPageChanged: widget.onPageChange,
        scrollDirection: Axis.vertical,
        children: _pageMaker(),
      ),
    );
  }
}
