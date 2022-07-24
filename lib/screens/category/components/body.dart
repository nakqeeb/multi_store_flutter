import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/category_provider.dart';
import 'package:multi_store_app/services/utils.dart';
import 'package:provider/provider.dart';

import 'category_view.dart';
import 'side_navigator.dart';

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /* List<ItemsData> items = [
    ItemsData(icon: Icons.man, label: 'men'),
    ItemsData(icon: Icons.woman, label: 'women'),
    ItemsData(icon: Icons.ac_unit, label: 'shoes'),
    ItemsData(icon: Icons.luggage, label: 'bags'),
    ItemsData(icon: Icons.laptop, label: 'electronics'),
    ItemsData(icon: Icons.headphones, label: 'accessories'),
    ItemsData(icon: Icons.home, label: 'home & garden'),
    ItemsData(icon: Icons.child_care, label: 'kids'),
    ItemsData(icon: Icons.view_agenda, label: 'beauty'),
  ]; */
  late CategoryProvider _categoryProvider;
  final PageController _pageController = PageController();

  @override
  void initState() {
    // set the categories back to first category navigate to CategoryScreen
    changeCategories(0);
    super.initState();
  }

  changeCategories(int index) {
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    for (var element in _categoryProvider.categories) {
      element.isSelected = false;
    }
    setState(() {
      _categoryProvider.categories[index].isSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          child: SideNavigator(
            categories: _categoryProvider.categories,
            onPress: (index) {
              // _pageController.jumpToPage(index); // L12
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              // changeCategories(index);
            },
          ),
        ),
        Positioned(
          right: 0,
          child: CategoryView(
            pageController: _pageController,
            categories: _categoryProvider.categories,
            onPageChange: (index) {
              changeCategories(index);
            },
          ),
        ),
      ],
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  IconData icon;
  ItemsData({required this.label, this.isSelected = false, required this.icon});
}
