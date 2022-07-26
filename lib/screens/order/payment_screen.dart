import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/bottom_bar/customer_bottom_bar.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/models/supplier.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:multi_store_app/utilities/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../components/default_button.dart';
import '../../models/cart_item.dart';
import '../../providers/auth_supplier_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/push_notification.dart';
import '../../services/utils.dart';

class PaymentScreen extends StatefulWidget {
  final AddressData address;
  const PaymentScreen({super.key, required this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedValue = 1;
  bool _isLoading = false;
  String? _supplierDeviceToken;

  Future<void> _placeOrder(List<CartItem>? cartItems) async {
    final authSupplierProvider =
        Provider.of<AuthSupplierProvider>(context, listen: false);
    final appLocale = AppLocalizations.of(context);
    GlobalMethods.loadingDialog(
        title: appLocale!.order_is_processing, context: context);
    for (var item in cartItems!) {
      await authSupplierProvider
          .fetchProductSupplierById(item.cartProduct!.supplier!);
      _supplierDeviceToken = authSupplierProvider.productSupplier!.fcmToken;
      print('This is device  token $_supplierDeviceToken');
      final newOrder = {
        "supplierId": item.cartProduct!.supplier,
        "addressId": widget.address.id,
        "name": widget.address.name,
        "phone": widget.address.phone,
        "pincode": widget.address.pincode,
        "address": widget.address.address,
        "landmark": widget.address.landmark,
        "city": widget.address.city,
        "state": widget.address.state,
        "productId": item.cartProduct!.id,
        "productName": item.cartProduct!.productName,
        "productImage": item.cartProduct!.productImages![0],
        "productPrice": item.cartProduct!.price,
        "orderQuantity": item.quantity,
        "orderPrice": item.quantity! * item.cartProduct!.price!.toDouble(),
        "paymentStatus": 'cash on delivery',
        "deliveryDate": '',
        "orderDate": DateTime.now().toIso8601String()
      };
      await context.read<OrderProvider>().placeOrder(newOrder);
      await PushNotification.sendNotificationNow(
        deviceRegistrationToken: _supplierDeviceToken!,
        title: appLocale.new_order,
        body: appLocale.you_have_new_order,
      );
    }
    await context.read<CartProvider>().clearCart();
    // close loading dialog
    Navigator.canPop(context) ? Navigator.pop(context) : null;
    // cloase showModalBottomSheet (to not allow user navigate to payment screen when return back)
    Navigator.of(context).popUntil((route) => route.isFirst);
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
    final appLocale = AppLocalizations.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart?.items;
    final totalPaid = cartProvider.totalPrice + 10.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(title: appLocale!.payment),
        leading: const AppBarBackButton(),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                              appLocale.total,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              '${totalPaid.toStringAsFixed(2)} ${appLocale.usd}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                              appLocale.order_total,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              '${cartProvider.totalPrice.toStringAsFixed(2)} ${appLocale.usd}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                              appLocale.shipping_cost,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              '10.00 ${appLocale.usd}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                        title: Text(appLocale.cashOnDelivery),
                        subtitle: Text(appLocale.pay_cash_at_home),
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                        title: Text(appLocale.pay_via_visa_mastercard),
                        subtitle: Row(
                          children: const [
                            Icon(Icons.payment, color: Colors.blue),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(FontAwesomeIcons.ccMastercard,
                                  color: Colors.blue),
                            ),
                            Icon(FontAwesomeIcons.ccVisa, color: Colors.blue)
                          ],
                        ),
                      ),
                      /* RadioListTile(
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
                      ), */
                    ],
                  )),
              SizedBox(
                height: size.height * 0.03,
              ),
              DefaultButton(
                onPressed: _isLoading
                    ? null
                    : () async {
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
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${appLocale.pay_at_home} ${totalPaid.toStringAsFixed(2)} \$',
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
                                          await _placeOrder(cartItems);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: appLocale
                                                  .order_placed_successfully,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.8),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        },
                                        height: size.height * 0.06,
                                        width: size.width * 0.9,
                                        radius: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        widget: Text(
                                          '${appLocale.confirm} ${totalPaid.toStringAsFixed(2)} ${appLocale.usd}',
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

                          int payment = totalPaid.round();
                          int pay = payment * 100;
                          await makePayment(cartItems!, pay.toString());
                        } /* else if (_selectedValue == 3) {
                          print('PayPal');
                        } */
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
                        '${appLocale.confirm} ${totalPaid.toStringAsFixed(2)} ${appLocale.usd}',
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
    );
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(List<CartItem> cartItems, String total) async {
    try {
      paymentIntentData = await createPaymentIntent(total, 'INR');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: const PaymentSheetApplePay(merchantCountryCode: 'IN'),
              googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'IN', testEnv: true),
              merchantDisplayName: 'Yafey'));

      await displayPaymentSheet(cartItems);
    } catch (e) {
      print('exception:$e');
    }
  }

  displayPaymentSheet(List<CartItem> cartItems) async {
    final authSupplierProvider =
        Provider.of<AuthSupplierProvider>(context, listen: false);
    final appLocale = AppLocalizations.of(context);
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        paymentIntentData = null;
        print('paid');

        GlobalMethods.loadingDialog(
            title: appLocale!.order_is_processing, context: context);
        for (var item in cartItems) {
          await authSupplierProvider
              .fetchProductSupplierById(item.cartProduct!.supplier!);
          _supplierDeviceToken = authSupplierProvider.productSupplier!.fcmToken;
          final newOrder = {
            "supplierId": item.cartProduct!.supplier,
            "addressId": widget.address.id,
            "name": widget.address.name,
            "phone": widget.address.phone,
            "pincode": widget.address.pincode,
            "address": widget.address.address,
            "landmark": widget.address.landmark,
            "city": widget.address.city,
            "state": widget.address.state,
            "productId": item.cartProduct!.id,
            "productName": item.cartProduct!.productName,
            "productImage": item.cartProduct!.productImages![0],
            "productPrice": item.cartProduct!.price,
            "orderQuantity": item.quantity,
            "orderPrice": item.quantity! * item.cartProduct!.price!.toDouble(),
            "paymentStatus": 'paid by VISA',
            "deliveryDate": '',
            "orderDate": DateTime.now().toIso8601String()
          };

          await context.read<OrderProvider>().placeOrder(newOrder);
          await PushNotification.sendNotificationNow(
            deviceRegistrationToken: _supplierDeviceToken!,
            title: appLocale.new_order,
            body: appLocale.you_have_new_order,
          );
        }
        await context.read<CartProvider>().clearCart();

        // close loading dialog
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        // cloase showModalBottomSheet (to not allow user navigate to payment screen when return back)
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => const CustomerBottomBar(),
          ),
        );

        Fluttertoast.showToast(
            msg: appLocale.order_placed_successfully,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.8),
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }
}
