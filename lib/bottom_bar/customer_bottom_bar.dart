import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/screens/cart/cart_screen.dart';
import 'package:multi_store_app/screens/category/category_screen.dart';
import 'package:multi_store_app/screens/home/home_screen.dart';
import 'package:multi_store_app/screens/profile/profile_screen.dart';
import 'package:multi_store_app/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CustomerBottomBar extends StatefulWidget {
  static String routeName = '/customer_btm_bar';
  const CustomerBottomBar({super.key});

  @override
  State<CustomerBottomBar> createState() => _CustomerBottomBarState();
}

class _CustomerBottomBarState extends State<CustomerBottomBar> {
  var _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoresScreen(),
    CartScreen(),
    ProfileScreen(),
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
            icon: const Icon(Icons.shop),
            label: appLocale.stores,
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (ctx, cartProvider, _) => Badge(
                badgeColor: Theme.of(context).colorScheme.primary,
                badgeContent: cartProvider.cart?.items == null
                    ? const Text('0')
                    : Text(cartProvider.cart!.items!.length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
            label: appLocale.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: appLocale.profile,
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
