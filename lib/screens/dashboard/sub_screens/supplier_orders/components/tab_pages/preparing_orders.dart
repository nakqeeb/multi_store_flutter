import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../../models/order.dart';
import '../../../../../error/error_screen.dart';
import '../expansion_supplier_order_tile.dart';

class PreparingOrders extends StatefulWidget {
  Future<List<Order>> ordersFuture;
  PreparingOrders({super.key, required this.ordersFuture});

  @override
  State<PreparingOrders> createState() => _PreparingOrdersState();
}

class _PreparingOrdersState extends State<PreparingOrders> {
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return FutureBuilder<List<Order>>(
        //stream: Stream.fromFuture(widget.ordersFuture!),
        future: widget.ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingFour(
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Order> orders = snapshot.data!
                .where(
                  (element) => element.deliveryStatus == 'preparing',
                )
                .toList();
            if (snapshot.hasError) {
              return ErrorScreen(
                  title: appLocale!.opps_went_wrong,
                  subTitle: appLocale.try_to_reload_app);
            } else if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, index) {
                  return ExpansionSupplierOrderTile(
                      key: ValueKey(orders[index].id), order: orders[index]);
                },
              );
            } else if (orders.isEmpty) {
              return Center(
                child: Text(
                  appLocale!.no_orders_prepared,
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
                  appLocale!.no_orders_loaded,
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
        });
  }
}
