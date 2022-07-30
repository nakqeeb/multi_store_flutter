import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/bottom_bar/customer_bottom_bar.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../services/utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedValue = 1;
  bool _isLoading = false;

  Future<void> placeOrder(List<CartItem>? cartItems) async {
    for (var item in cartItems!) {
      final newOrder = {
        "supplier": item.cartProduct?.supplier,
        "product": item.cartProduct?.id,
        "orderQuantity": item.quantity,
        "orderPrice": item.quantity! * item.cartProduct!.price!.toDouble(),
        "deliveryDate": '',
        "orderDate": DateTime.now().toIso8601String()
      };
      await context.read<OrderProvider>().placeOrder(newOrder);
    }
    await context.read<CartProvider>().clearCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CustomerBottomBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart?.items;
    final totalPaid = cartProvider.totalPrice + 10.0;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Payment'),
        leading: const AppBarBackButton(),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _isLoading
                ? [
                    Container(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                      ),
                    )
                  ]
                : [],
          ),
          Center(
            child: SizedBox(
              width: size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.14,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                Text(
                                  '${totalPaid.toStringAsFixed(2)} USD',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              height: size.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Total',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                Text(
                                  '${cartProvider.totalPrice.toStringAsFixed(2)} USD',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping Cost',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                Text(
                                  '10.00 USD',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                      width: double.infinity,
                      height: (size.height * 0.72) -
                          kToolbarHeight -
                          kBottomNavigationBarHeight,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            title: const Text('Cash On Delivery'),
                            subtitle: const Text('Pay Cash At Home'),
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            title: const Text('Pay via visa / Master Card'),
                            subtitle: Row(
                              children: const [
                                Icon(Icons.payment, color: Colors.blue),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Icon(FontAwesomeIcons.ccMastercard,
                                      color: Colors.blue),
                                ),
                                Icon(FontAwesomeIcons.ccVisa,
                                    color: Colors.blue)
                              ],
                            ),
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            title: const Text('Pay via Paypal'),
                            subtitle: Row(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.paypal,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  FontAwesomeIcons.ccPaypal,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  DefaultButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            print(_selectedValue);
                            if (_selectedValue == 1) {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Pay At Home ${totalPaid.toStringAsFixed(2)} \$',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        DefaultButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              if (Navigator.canPop(context)) {
                                                Navigator.pop(context);
                                              }
                                              await placeOrder(cartItems);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                            height: size.height * 0.06,
                                            width: size.width * 0.9,
                                            radius: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            widget: Text(
                                              'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (_selectedValue == 2) {
                              print('Visa');
                            } else if (_selectedValue == 3) {
                              print('PayPal');
                            }
                          },
                    height: size.height * 0.06,
                    width: double.infinity,
                    radius: 15,
                    color: Theme.of(context).colorScheme.primary,
                    widget: _isLoading
                        ? SpinKitFoldingCube(
                            color: Theme.of(context).colorScheme.secondary,
                            size: 18,
                          )
                        : Text(
                            'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
