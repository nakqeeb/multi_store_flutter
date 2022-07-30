import 'package:flutter/material.dart';
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
  Future<List<Order>>? _orders;
  @override
  void initState() {
    _orders = Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(
          title: 'Orders',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Order>>(
          future: _orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitFadingFour(
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const ErrorScreen(
                    title: 'Opps! Something went wrong',
                    subTitle: 'Please try to reload the application!');
              } else if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index) {
                    return ExpansionOrderTile(order: snapshot.data![index]);
                  },
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'You haven\'t order anything yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'No Orders loaded!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
