import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/home/components/gallery_tab_screen.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/category_provider.dart';
import 'components/body.dart';
import 'components/repeated_tab.dart';
import '../../components/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController? _tabController;
  List<Widget> _tabs = [];
  List<Widget> _generalWidgets = [];
  CategoryProvider? _categoryProvider;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _tabMaker() {
    _tabs.clear();
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    for (var i = 0; i < _categoryProvider!.categories.length; i++) {
      _tabs.add(RepeatedTab(
          label: _categoryProvider!.categories[i].enName.toString()));
    }
    return _tabs;
  }

  List<Widget> _tabBarViewMaker() {
    _generalWidgets.clear();
    final categories = Provider.of<CategoryProvider>(context).categories;
    for (int i = 0; i < categories.length; i++) {
      final catId = categories[i].id;
      _generalWidgets.add(GalleryTabScreen(
        categoryId: catId!,
      ));
    }
    return _generalWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).categories;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: appBar(),
        body: TabBarView(children: _tabBarViewMaker()),
      ),
    );
  }

  AppBar appBar() {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = Provider.of<CategoryProvider>(context).categories;
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      /* title: CupertinoSearchTextField(
        style: TextStyle(
          color:
              isDarkTheme ? const Color(0xFFfbe6ce) : const Color(0xFF4d3a6b),
        ),
      ), */
      title: const SearchBar(),
      bottom: TabBar(
        /* onTap: (index) async {
          final catId = categories[index].id;
          await productProvider.fetchProductsByCategoryId(catId!);
          print('This is category Id $catId');
          print('This is product by category id ${productProvider.products}');
        }, */
        controller: _tabController,
        isScrollable: true,
        indicatorWeight: 8,
        tabs: _tabMaker(),
      ),
    );
  }
}
