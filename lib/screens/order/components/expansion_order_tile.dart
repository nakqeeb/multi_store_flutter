import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:multi_store_app/models/order.dart';
import 'package:multi_store_app/screens/order/components/review_widget.dart';

import '../../../services/utils.dart';

class ExpansionOrderTile extends StatefulWidget {
  final Order order;
  const ExpansionOrderTile({super.key, required this.order});

  @override
  State<ExpansionOrderTile> createState() => _ExpansionOrderTileState();
}

class _ExpansionOrderTileState extends State<ExpansionOrderTile> {
  // https://peaku.co/questions/25591-el-analisis-de-la-fecha-de-mongodb-en-flutter-siempre-falla
  _getFormattedDateFromFormattedString(
      {required value,
      required String currentFormat,
      required String desiredFormat,
      isUtc = false}) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        dateTime =
            DateFormat(currentFormat).parse(value, isUtc = true).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    final deliveryStatus = widget.order.deliveryStatus.toString() == 'preparing'
        ? appLocale!.preparing
        : widget.order.deliveryStatus.toString() == 'shipping'
            ? appLocale!.shipping
            : widget.order.deliveryStatus.toString() == 'delivered'
                ? appLocale!.delivered
                : '';
    final paymentStatus = widget.order.paymentStatus == 'cash on delivery'
        ? appLocale!.cash_on_delivery
        : widget.order.paymentStatus == 'paid by VISA'
            ? appLocale!.paid_by_visa
            : '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.secondary),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.1, maxWidth: double.infinity),
            child: Row(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'images/inapp/spinner.gif',
                  image: widget.order.productImage.toString(),
                  height: double.infinity,
                  width: size.width * 0.20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.60,
                        child: Text(
                          widget.order.productName.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.order.productPrice!.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              'x ${widget.order.orderQuantity}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                '${appLocale!.total_price}:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                widget.order.orderPrice!.toStringAsFixed(2),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                deliveryStatus,
                style: TextStyle(
                  color: widget.order.deliveryStatus == 'preparing'
                      ? Colors.amber
                      : widget.order.deliveryStatus == 'shipping'
                          ? Colors.indigoAccent
                          : Colors.green,
                ),
              )
            ],
          ),
          children: [
            Container(
              //height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order.deliveryStatus == 'delivered'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${appLocale.name}: ${widget.order.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.phone}: ${widget.order.phone}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.address}: ${widget.order.address}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.landmark}: ${widget.order.landmark}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.province}: ${widget.order.state}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.city}: ${widget.order.city}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.pincode}: ${widget.order.pincode}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${appLocale.payment_status}: ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          paymentStatus,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${appLocale.delivery_status}: ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          deliveryStatus,
                          style: TextStyle(
                            fontSize: 15,
                            color: widget.order.deliveryStatus == 'preparing'
                                ? Colors.amber
                                : widget.order.deliveryStatus == 'shipping'
                                    ? Colors.indigoAccent
                                    : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    widget.order.deliveryStatus == 'shipping'
                        ? Text(
                            '${appLocale.estimated_delivery_date}: ${_getFormattedDateFromFormattedString(value: widget.order.deliveryDate, currentFormat: "yyyy-MM-ddTHH:mm:ssZ", desiredFormat: "yyyy-MM-dd").toString().split(' ')[0]}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.blue),
                          )
                        : const SizedBox.shrink(), // const Text(''),
                    widget.order.deliveryStatus == 'delivered' &&
                            widget.order.orderReview == false
                        ? TextButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withAlpha(230),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                builder: (ctx) => SingleChildScrollView(
                                  child: Padding(
                                    // added to show the model when above the keyboard
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(ctx)
                                            .viewInsets
                                            .bottom),
                                    child: SizedBox(
                                      height: size.height * 0.4,
                                      child: ReviewWidget(order: widget.order),
                                    ),
                                  ),
                                ),
                              ).then((value) {
                                setState(() {
                                  widget.order.orderReview = value;
                                });
                              });
                            },
                            child: Text(
                              appLocale.write_review,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(), // const Text(''),
                    widget.order.deliveryStatus == 'delivered' &&
                            widget.order.orderReview == true
                        ? Row(
                            children: [
                              const Icon(
                                Icons.check,
                              ),
                              Text(
                                appLocale.review_added,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          )
                        : const SizedBox.shrink() // const Text(''),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
