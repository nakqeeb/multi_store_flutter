import 'package:flutter/material.dart';
import 'package:multi_store_app/screens/category/category_screen.dart';
import 'package:multi_store_app/screens/dashboard/dashboard_screen.dart';
import 'package:multi_store_app/screens/home/home_screen.dart';
import 'package:multi_store_app/screens/stores/stores_screen.dart';
import 'package:multi_store_app/screens/upload_product/upload_product_screen.dart';

class SupplierBottomBar extends StatefulWidget {
  const SupplierBottomBar({super.key});

  @override
  State<SupplierBottomBar> createState() => _SupplierBottomBarState();
}

class _SupplierBottomBarState extends State<SupplierBottomBar> {
  var _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    DashboardScreen(),
    const UploadProductScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
