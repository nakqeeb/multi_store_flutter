import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multi_store_app/fetch_screen.dart';
import 'package:multi_store_app/models/cart.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/category_provider.dart';
import 'package:multi_store_app/providers/dark_theme_provider.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/utilities/theme.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/review_provider.dart';
import 'utilities/global_variables.dart';
import 'models/address.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthCustomerProvider()),
        ChangeNotifierProvider(create: (_) => AuthSupplierProvider()),
        ChangeNotifierProxyProvider<AuthSupplierProvider, ProductProvider>(
          create: (_) => ProductProvider(null, []),
          update: (BuildContext ctx, supplierAuth,
                  ProductProvider? previousProducts) =>
              ProductProvider(
            supplierAuth.token,
            previousProducts == null ? [] : previousProducts.products,
          ),
        ),
        // since supplier is the only one who can update products, we dont need to use ChangeNotifierProxyProvider2. Hence we will use ChangeNotifierProxyProvider instead. If both supplier and customer can update the products then we can use ChangeNotifierProxyProvider2, because we will need the authToken of both supplier and customer. Though if we use ChangeNotifierProxyProvider2 here it'll work fine
        /* ChangeNotifierProxyProvider2<AuthCustomerProvider, AuthSupplierProvider,
            ProductProvider>(
          create: (_) => ProductProvider(null, []),
          update: (BuildContext ctx, customerAuth, supplierAuth,
                  ProductProvider? previousProducts) =>
              ProductProvider(
            customerAuth.token ?? supplierAuth.token,
            previousProducts == null ? [] : previousProducts.products,
          ),
        ), */
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProxyProvider<AuthCustomerProvider, CartProvider>(
          create: (_) => CartProvider(null, Cart()),
          update:
              (BuildContext ctx, customerAuth, CartProvider? previousCart) =>
                  CartProvider(
            customerAuth.token,
            previousCart!.cart,
          ),
        ),
        ChangeNotifierProxyProvider2<AuthCustomerProvider, AuthSupplierProvider,
            OrderProvider>(
          create: (_) => OrderProvider(null, []),
          update: (BuildContext ctx, customerAuth, supplierAuth,
                  OrderProvider? previousOrders) =>
              OrderProvider(
            customerAuth.token ?? supplierAuth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProxyProvider<AuthCustomerProvider, ReviewProvider>(
          create: (_) => ReviewProvider(null, []),
          update: (BuildContext ctx, customerAuth,
                  ReviewProvider? previousOrders) =>
              ReviewProvider(
            customerAuth.token,
            previousOrders!.reviews,
          ),
        ),
        ChangeNotifierProxyProvider<AuthCustomerProvider, AddressProvider>(
          create: (_) => AddressProvider(null, [], AddressData()),
          update: (BuildContext ctx, customerAuth,
                  AddressProvider? previousaddresses) =>
              AddressProvider(customerAuth.token, previousaddresses!.addresses,
                  previousaddresses.address!),
        ),
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (_, themeProvider, child) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeProvider.isDarkTheme, context),
          home: const FetchScreen(),
        ),
      ),
    );
  }
}
