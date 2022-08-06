import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_store_app/models/order.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/screens/order/components/review_widget.dart';
import 'package:provider/provider.dart';

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
                  image: widget.order.product!.productImages![0],
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
                          widget.order.product!.productName.toString(),
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
                              widget.order.product!.price!.toStringAsFixed(2),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'See more...',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7)),
              ),
              Text(
                widget.order.deliveryStatus.toString(),
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
                      'Name: ${widget.order.customer?.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Phone No: ${widget.order.customer?.phone}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Email: ${widget.order.customer?.email}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Address: ${widget.order.customer?.address}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${widget.order.paymentStatus}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${widget.order.deliveryStatus}',
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
                            'Estimated Delivey Date: ${_getFormattedDateFromFormattedString(value: widget.order.deliveryDate, currentFormat: "yyyy-MM-ddTHH:mm:ssZ", desiredFormat: "yyyy-MM-dd").toString().split(' ')[0]}',
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
                            child: const Text(
                              'Write Review',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(), // const Text(''),
                    widget.order.deliveryStatus == 'delivered' &&
                            widget.order.orderReview == true
                        ? Row(
                            children: const [
                              Icon(
                                Icons.check,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
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
