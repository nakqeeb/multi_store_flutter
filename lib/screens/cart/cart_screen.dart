import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/screens/cart/components/btm_sheet.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_customer_provider.dart';
import '../../providers/dark_theme_provider.dart';
import 'components/cart_items.dart';
import 'components/empty_cart.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({super.key, this.back});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isClearingCart = false;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final isCustomerAuth = context.read<AuthCustomerProvider>().isAuth;
    final appLocale = AppLocalizations.of(context);
    // Wrap by material to show notification bar when navigate to CartScreen from "Cart" button in ProfileScreen
    // without Material, when navigate from Cart button, the noti bar will be showing as black
    return Material(
      color: isDarkTheme
          ? const Color(0xFF1c2732)
          : const Color(0xFFf9f7f7), // notification bar color
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: widget.back,
            elevation: 0,
            centerTitle: true,
            title: AppBarTitle(title: appLocale!.cart),
            actions: isCustomerAuth
                ? [
                    IconButton(
                      onPressed: context
                              .read<CartProvider>()
                              .cart!
                              .items!
                              .isEmpty
                          ? null
                          : () {
                              GlobalMethods.warningDialog(
                                title: appLocale.clear_cart,
                                subtitle: appLocale.are_you_sure_to_clear_cart,
                                fct: () async {
                                  setState(() {
                                    _isClearingCart = true;
                                  });
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  await Provider.of<CartProvider>(context,
                                          listen: false)
                                      .clearCart();

                                  setState(() {
                                    _isClearingCart = false;
                                  });
                                },
                                context: context,
                              );
                            },
                      tooltip: appLocale.clear_cart,
                      icon: Icon(
                        Icons.delete_forever,
                        color: context.read<CartProvider>().cart!.items!.isEmpty
                            ? Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.3)
                            : Theme.of(context).iconTheme.color,
                      ),
                    )
                  ]
                : [],
          ),
          body: _isClearingCart
              ? GlobalMethods.loadingScreen()
              : isCustomerAuth
                  ? (context.watch<CartProvider>().cart!.items!.isNotEmpty
                      ? const CartItems()
                      : EmptyCart(
                          textTitle: appLocale.cart_empty,
                          buttonTitle: appLocale.continue_shopping))
                  : EmptyCart(
                      textTitle: appLocale.login_to_see_cart,
                      buttonTitle: appLocale.login,
                      isGuest: true,
                    ),
          bottomSheet: const BTMSheet(),
        ),
      ),
    );
  }
}
