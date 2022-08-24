import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/screens/order/place_order_screen.dart';
import 'package:provider/provider.dart';
import '../../../components/default_button.dart';
import '../../../services/utils.dart';

class BTMSheet extends StatelessWidget {
  const BTMSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    var total = context.watch<CartProvider>().totalPrice;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Text(
            '${appLocale!.total}: \$ ',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            total.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Spacer(),
          DefaultButton(
            onPressed: total == 0.0
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const PlaceOrderScreen(),
                      ),
                    );
                  },
            height: size.height * 0.057,
            width: size.width * 0.45,
            color: total == 0.0
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Theme.of(context).colorScheme.primary,
            radius: 10,
            widget: Text(
              appLocale.checkout,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
