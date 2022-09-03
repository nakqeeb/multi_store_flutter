import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:provider/provider.dart';

import '../../../../components/app_bar_back_button.dart';
import '../../../../components/app_bar_title.dart';
import '../../../../models/order.dart';
import '../../../../providers/order_provider.dart';
import '../../../../services/utils.dart';
import '../../../error/error_screen.dart';
import '../../components/statics_widget.dart';

class SupplierBalanceScreen extends StatelessWidget {
  const SupplierBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: AppBarTitle(
          title: appLocale!.balance,
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
                return ErrorScreen(
                    title: appLocale.opps_went_wrong,
                    subTitle: appLocale.try_to_reload_app);
              } else if (orders.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StaticsWidget(
                        label: appLocale.total_balance.toString().toUpperCase(),
                        value: totalPrice,
                        decimal: 2,
                      ),
                      DefaultButton(
                        onPressed: () {},
                        height: size.height * 0.06,
                        width: size.width * 0.7,
                        radius: 25,
                        color: Theme.of(context).colorScheme.tertiary,
                        widget: Text(
                          appLocale.collect_my_money,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (orders.isEmpty) {
                return Center(
                  child: Text(
                    appLocale.no_balance,
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
                    appLocale.opps_went_wrong,
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
