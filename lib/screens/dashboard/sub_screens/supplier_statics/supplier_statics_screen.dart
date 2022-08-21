import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../../../../components/app_bar_back_button.dart';
import '../../../../components/app_bar_title.dart';
import '../../../../models/order.dart';
import '../../../error/error_screen.dart';
import '../../components/statics_widget.dart';

class SupplierStaticsScreen extends StatelessWidget {
  const SupplierStaticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(
          title: 'My Statics',
        ),
      ),
      body: FutureBuilder<List<Order>>(
          future: context.read<OrderProvider>().fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitFadingFour(
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Order> orders = snapshot.data!;
              var itemCount = 0;
              var totalPrice = 0.0;
              for (var item in orders) {
                itemCount += item.orderQuantity!;
                totalPrice += item.orderPrice!;
              }
              if (snapshot.hasError) {
                return const ErrorScreen(
                    title: 'Opps! Something went wrong',
                    subTitle: 'Please try to reload the application!');
              } else if (orders.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StaticsWidget(
                        label: 'SOLD OUT',
                        value: orders.length,
                        decimal: 0,
                      ),
                      StaticsWidget(
                        label: 'ITEM COUNT',
                        value: itemCount,
                        decimal: 0,
                      ),
                      StaticsWidget(
                        label: 'TOTAL BALANCE',
                        value: totalPrice,
                        decimal: 2,
                      ),
                      const SizedBox(),
                    ],
                  ),
                );
              } else if (orders.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no orders yet!',
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
