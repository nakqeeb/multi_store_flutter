import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/search/components/searched_product_tile.dart';
import 'package:provider/provider.dart';
import '../../providers/dark_theme_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchInput = '';
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchInput = value;
            });
          },
          style: TextStyle(
            color:
                isDarkTheme ? const Color(0xFFdae3e3) : const Color(0xFF758699),
          ),
        ),
      ),
      body: _searchInput == ''
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.search,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Search for the product.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView(
              children: productProvider
                  .searchQuery(_searchInput)
                  .map((e) => SearchedProductTile(product: e))
                  .toList(),
            ),
    );
  }
}
