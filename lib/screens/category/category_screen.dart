import 'package:flutter/material.dart';
import 'package:multi_store_app/components/search_bar.dart';
import 'components/body.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const SearchBar()),
      body: SafeArea(child: Body()),
    );
  }
}
