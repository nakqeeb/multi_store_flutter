import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart'; // .firstWhereOrNull()
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/screens/address/address_screen.dart';
import 'package:multi_store_app/screens/order/components/address_info.dart';
import 'package:multi_store_app/screens/order/payment_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../providers/auth_customer_provider.dart';
import '../../services/utils.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  AddressData? _address;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    //final address = authCustomerProvider.customer?.address;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart?.items;

    final addressProvider = Provider.of<AddressProvider>(context);
    _address = addressProvider.addresses
        .firstWhereOrNull((element) => element.isDefault == true);

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(
            title: appLocale!.place_order,
          ),
          leading: const AppBarBackButton(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _address == null
                    ? DefaultButton(
                        onPressed: () async {
                          final response = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddressScreen(),
                            ),
                          );
                          if (response == true) {
                            _address = addressProvider.addresses
                                .firstWhereOrNull(
                                    (element) => element.isDefault == true);
                          }
                        },
                        height: size.height * 0.05,
                        width: size.width * 0.7,
                        radius: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              appLocale.add_address,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: AddressInfo(
                          onPressed: () {},
                          name: _address!.name!.toUpperCase(),
                          phone: _address!.phone.toString(),
                          address: _address!.address.toString(),
                          landmark: _address!.landmark.toString(),
                          city: _address!.city.toString(),
                          state: _address!.state.toString(),
                          pincode: _address!.pincode.toString(),
                        ),
                      ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  width: size.width * 0.9,
                  height: (size.height * 0.7) -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ListView.builder(
                        itemCount: cartItems?.length,
                        itemBuilder: (ctx, index) {
                          final isOnSale =
                              cartItems![index].cartProduct!.discount! > 0;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.9,
                              height: size.height * 0.13,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/inapp/spinner.gif',
                                      image: cartItems[index]
                                          .cartProduct!
                                          .productImages![0],
                                      height: double.infinity,
                                      width: size.width * 0.20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.60,
                                        child: Text(
                                          cartItems[index]
                                              .cartProduct!
                                              .productName
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: size.width * 0.60,
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  cartItems[index]
                                                      .cartProduct!
                                                      .price!
                                                      .toStringAsFixed(2),
                                                  style: isOnSale
                                                      ? TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .secondary
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)
                                                      : const TextStyle(
                                                          color: Colors.indigo,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                isOnSale
                                                    ? Text(
                                                        ((1 -
                                                                    (cartItems[index]
                                                                            .cartProduct!
                                                                            .discount! /
                                                                        100)) *
                                                                cartItems[index]
                                                                    .cartProduct!
                                                                    .price!)
                                                            .toStringAsFixed(2),
                                                        style: const TextStyle(
                                                          color: Colors.indigo,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              'x ${cartItems[index].quantity}',
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                DefaultButton(
                  onPressed: () {
                    if (_address == null) {
                      GlobalMethods.showSnackBar(
                          context, _scaffoldKey, appLocale.pick_address);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => PaymentScreen(address: _address!),
                      ),
                    );
                  },
                  height: size.height * 0.06,
                  width: size.width * 0.9,
                  radius: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  widget: Text(
                    '${appLocale.confirm} ${cartProvider.totalPrice.toStringAsFixed(2)} ${appLocale.usd}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
