import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/bottom_bar/customer_bottom_bar.dart';
import 'package:multi_store_app/bottom_bar/supplier_bottom_bar.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/category_provider.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'providers/address_provider.dart';
import 'screens/error/error_screen.dart';

// we need to set it in the main.dart as a home instead of BottomBarScreen()
// also we need to call it in login and register screens once the user loged in or regestered instead of BottomBarScreen(),
// L103
class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final List<String> _images = [
    'images/landing/buy-on-laptop.jpg',
    'images/landing/buy-access.jpg',
    'images/landing/buy-cart.jpg',
    'images/landing/buy-clothes.jpg',
    'images/landing/buy-gifts.jpg',
  ];
  // L103
  @override
  void initState() {
    _images.shuffle();
    final authCustomerProvider =
        Provider.of<AuthCustomerProvider>(context, listen: false);
    final authSupplierProvider =
        Provider.of<AuthSupplierProvider>(context, listen: false);

    Future.delayed(const Duration(microseconds: 5), () async {
      final appLocale = AppLocalizations.of(context);
      //check network availability
      var connectivityResult = await Connectivity().checkConnectivity();
      // check if the user is not connected to mobile network and wifi.
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => ErrorScreen(
            title: appLocale!.noInternet,
            subTitle: appLocale.check_your_connection,
          ),
        ));
        return;
      }
      await authCustomerProvider.tryAutoLogin();
      await authSupplierProvider.tryAutoLogin();
      // await authSupplierProvider.fetchSuppliers();
      final isCusAuth = authCustomerProvider.isAuth;
      final isSubAuth = authSupplierProvider.isAuth;
      var timeoutError;
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchCategories()
          .catchError((err) {
        print(err);
        timeoutError = err;
      });

      if (timeoutError != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => ErrorScreen(
            title: appLocale!.opps_went_wrong,
            subTitle: appLocale.try_to_reload_app,
          ),
        ));
        return;
      }

      if (timeoutError != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => ErrorScreen(
            title: appLocale!.opps_went_wrong,
            subTitle: appLocale.try_to_reload_app,
          ),
        ));
        return;
      }
      if (isCusAuth && !isSubAuth) {
        await Provider.of<CartProvider>(context, listen: false).fetchCart();
        await Provider.of<WishlistProvider>(context, listen: false)
            .fetchWishlist();
        await Provider.of<AddressProvider>(context, listen: false)
            .fetchAddresses();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const CustomerBottomBar(),
        ));
        // Create empty cart for the customer if no cart is found
      } else if (isSubAuth && !isCusAuth) {
        await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const SupplierBottomBar(),
        ));
      } else {
        await authCustomerProvider.logout();
        await authSupplierProvider.logout();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const WelcomeScreen(),
        ));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
