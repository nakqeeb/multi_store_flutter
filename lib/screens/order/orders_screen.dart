import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/order.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/screens/order/components/expansion_order_tile.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/app_bar_title.dart';
import '../error/error_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //Future<List<Order>>? _orders;

  @override
  void initState() {
    //_orders = Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
        title: AppBarTitle(
          title: appLocale!.orders,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Order>>(
          // future: _orders,
          stream: Stream.fromFuture(
              Provider.of<OrderProvider>(context, listen: false).fetchOrders()),
          builder: (context, AsyncSnapshot<List<Order>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //print('this is snapshot1 ${snapshot.data}');
              return SpinKitFadingFour(
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              print('this is snapshot2 ${snapshot.data}');
              List<Order> orders = snapshot.data!.reversed.toList();
              if (snapshot.hasError) {
                return ErrorScreen(
                    title: appLocale.opps_went_wrong,
                    subTitle: appLocale.try_to_reload_app);
              } else if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index) {
                    return ExpansionOrderTile(order: snapshot.data![index]);
                  },
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    appLocale.no_order_yet,
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
                    appLocale.no_orders_loaded,
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
              return Center(child: Text('State: ${snapshot.connectionState}'));
            }
          }),
    );
  }
}
