import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/screens/category/category_screen.dart';
import 'package:multi_store_app/screens/dashboard/dashboard_screen.dart';
import 'package:multi_store_app/screens/home/home_screen.dart';
import 'package:multi_store_app/screens/stores/stores_screen.dart';
import 'package:multi_store_app/screens/upload_product/upload_product_screen.dart';
import 'package:provider/provider.dart';

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
    const DashboardScreen(),
    const UploadProductScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: appLocale!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: appLocale.category,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: appLocale.stores,
          ),
          BottomNavigationBarItem(
            icon: Consumer<OrderProvider>(builder: (ctx, orderProvider, _) {
              var preparingOrder = orderProvider.orders
                  .where(
                    (element) => element.deliveryStatus == 'preparing',
                  )
                  .toList();
              return Badge(
                badgeColor: Theme.of(context).colorScheme.primary,
                badgeContent: preparingOrder.isEmpty
                    ? const Text(
                        '0',
                        style: TextStyle(fontSize: 12),
                      )
                    : Text(
                        preparingOrder.length.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                child: const Icon(Icons.dashboard),
              );
            }),
            label: appLocale.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.upload),
            label: appLocale.upload,
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
