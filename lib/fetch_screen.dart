import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/bottom_bar/customer_bottom_bar.dart';
import 'package:multi_store_app/bottom_bar/supplier_bottom_bar.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/category_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/customer.dart';
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
      //check network availability
      var connectivityResult = await Connectivity().checkConnectivity();
      // check if the user is not connected to mobile network and wifi.
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const ErrorScreen(
            title: "No internet connection",
            subTitle:
                "Please check your internet connection first and try again !",
          ),
        ));
        return;
      }
      await authCustomerProvider.tryAutoLogin();
      await authSupplierProvider.tryAutoLogin();
      await authSupplierProvider.fetchSuppliers();
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
          builder: (ctx) => const ErrorScreen(
            title: "Opps",
            subTitle: "Something went wrong !",
          ),
        ));
        return;
      }
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts()
          .catchError((err) {
        print(err);
        timeoutError = err;
      });

      if (timeoutError != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const ErrorScreen(
            title: "Oops",
            subTitle: "Something went wrong, please try again later!",
          ),
        ));
        return;
      }
      if (isCusAuth && !isSubAuth) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const CustomerBottomBar(),
        ));
        // Create empty cart for the customer if no cart is found
        await Provider.of<CartProvider>(context, listen: false).fetchCart();
      } else if (isSubAuth && !isCusAuth) {
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
