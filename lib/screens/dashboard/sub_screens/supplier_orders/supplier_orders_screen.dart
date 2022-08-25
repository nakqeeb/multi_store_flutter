import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../components/app_bar_back_button.dart';
import '../../../../components/app_bar_title.dart';
import '../../../../models/order.dart';
import '../../../../providers/order_provider.dart';
import 'components/supplier_order_tab.dart';
import 'components/tab_pages/delivered_orders.dart';
import 'components/tab_pages/preparing_orders.dart';
import 'components/tab_pages/shipping_orders.dart';

class SupplierOrdersScreen extends StatefulWidget {
  const SupplierOrdersScreen({Key? key}) : super(key: key);

  @override
  State<SupplierOrdersScreen> createState() => _SupplierOrdersScreenState();
}

class _SupplierOrdersScreenState extends State<SupplierOrdersScreen> {
  late Future<List<Order>> _ordersFuture;
  final _sockerURL = 'http://192.168.0.111:3000';
  IO.Socket? _socket;

  static const _socketEvent = 'event_1';

  void connect() {
    _socket = IO.io(_sockerURL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    _socket!.connect();
    _socket!.onConnect((data) => print('Connected'));
    print(_socket!.connected);
    _socket!.on('orders', (data) {
      print(data);
      // print(data['action']);
      if (data['action'] == 'updateOrder') {
        Order updatedOrder = Order.fromJson(data['order']);
        Provider.of<OrderProvider>(context, listen: false).setOrder =
            updatedOrder;

        /* _ordersFuture =
            Provider.of<OrderProvider>(context, listen: true).fetchOrders(); */
        //print(Provider.of<OrderProvider>(context, listen: true).orders);
        print('This is updated order: ${updatedOrder.deliveryDate}');
        setState(() {});
      }
    }); // 'products' in .on() is the event name that I use in the backend
  }

  @override
  void initState() {
    _ordersFuture =
        Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    connect();
    // connect();
    super.initState();
  }

  @override
  void dispose() {
    _socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: const AppBarBackButton(),
          title: AppBarTitle(
            title: appLocale!.orders,
          ),
          bottom: TabBar(indicatorWeight: 1, tabs: [
            SupplierOrderTab(label: appLocale.preparing.toUpperCase()),
            SupplierOrderTab(label: appLocale.shipping.toUpperCase()),
            SupplierOrderTab(label: appLocale.delivered.toUpperCase()),
          ]),
        ),
        body: TabBarView(children: [
          PreparingOrders(ordersFuture: _ordersFuture),
          ShippingOrders(ordersFuture: _ordersFuture),
          DeliveredOrders(
            ordersFuture: _ordersFuture,
          ),
        ]),
      ),
    );
  }
}
