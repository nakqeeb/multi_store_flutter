import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/screens/order/payment_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final authCustomerProvider = Provider.of<AuthCustomerProvider>(context);
    final name = authCustomerProvider.customer?.name;
    final phone = authCustomerProvider.customer?.phone;
    //final address = authCustomerProvider.customer?.address;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart?.items;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(
          title: 'Place Order',
        ),
        leading: const AppBarBackButton(),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: $name',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'Phone No: $phone',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      /* Text(
                        'Address: $address',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary),
                      ), */
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              width: size.width * 0.9,
              height: (size.height * 0.74) -
                  kToolbarHeight -
                  kBottomNavigationBarHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                          .withOpacity(0.7),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const PaymentScreen(),
                  ),
                );
              },
              height: size.height * 0.06,
              width: size.width * 0.9,
              radius: 15,
              color: Theme.of(context).colorScheme.secondary,
              widget: Text(
                'Confirm ${cartProvider.totalPrice.toStringAsFixed(2)} USD',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
