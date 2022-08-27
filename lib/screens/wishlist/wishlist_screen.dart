import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/screens/wishlist/components/wish_tile.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../components/app_bar_back_button.dart';
import '../../components/app_bar_title.dart';
import '../../providers/dark_theme_provider.dart';
import '../error/error_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<Product>> _futureWishlistProducts;

  @override
  void initState() {
    _futureWishlistProducts =
        Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (context.read<WishlistProvider>().isRemoved) {
      _futureWishlistProducts =
          Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    }
    context.watch<WishlistProvider>().isRemoved = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    return Material(
      color:
          isDarkTheme ? const Color(0xFF1c2732) : const Color(0xFFf9f7f7), // n
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: const AppBarBackButton(),
            title: AppBarTitle(title: appLocale!.wishlist),
            centerTitle: true,
          ),
          body: FutureBuilder<List<Product>>(
            future: _futureWishlistProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //print('this is snapshot1 ${snapshot.data}');
                return SpinKitFadingFour(
                  color: Theme.of(context).colorScheme.secondary,
                  size: 35,
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                print('this is snapshot2 ${snapshot.data}');
                if (snapshot.hasError) {
                  return ErrorScreen(
                      title: appLocale.opps_went_wrong,
                      subTitle: appLocale.try_to_reload_app);
                } else if (snapshot.data!.isNotEmpty) {
                  List<Product> wishlistProducts = snapshot.data!;
                  return ListView.builder(
                      itemCount: wishlistProducts.length,
                      itemBuilder: (context, index) {
                        return WishTile(
                          key: ValueKey(wishlistProducts[index].id),
                          product: wishlistProducts[index],
                        );
                      });
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      appLocale.no_wishlist_yet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme',
                          letterSpacing: 1.5),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      appLocale.no_wishlist_loaded,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme',
                          letterSpacing: 1.5),
                    ),
                  );
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            },
          ),
        ),
      ),
    );
  }
}
