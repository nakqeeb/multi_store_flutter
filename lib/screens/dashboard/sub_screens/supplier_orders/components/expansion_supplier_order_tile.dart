import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/order.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../services/utils.dart';

class ExpansionSupplierOrderTile extends StatelessWidget {
  final Order order;
  const ExpansionSupplierOrderTile({super.key, required this.order});

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
    final orderProvider = Provider.of<OrderProvider>(context);
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
                  image: order.productImage.toString(),
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
                          order.productName.toString(),
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
                              order.productPrice!.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              'x ${order.orderQuantity}',
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
                'Total Price:',
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
                order.orderPrice!.toStringAsFixed(2),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                order.deliveryStatus.toString(),
                style: TextStyle(
                    color: order.deliveryStatus == 'preparing'
                        ? Colors.amber
                        : order.deliveryStatus == 'shipping'
                            ? Colors.indigoAccent
                            : Colors.green),
              )
            ],
          ),
          children: [
            Container(
              //height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: order.deliveryStatus == 'delivered'
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
                      'Name: ${order.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Phone No: ${order.phone}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Address: ${order.address}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Landmark: ${order.landmark}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'State: ${order.state}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'City: ${order.city}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Pincode: ${order.pincode}',
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
                          '${order.paymentStatus}',
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
                          '${order.deliveryStatus}',
                          style: TextStyle(
                              fontSize: 15,
                              color: order.deliveryStatus == 'preparing'
                                  ? Colors.amber
                                  : order.deliveryStatus == 'shipping'
                                      ? Colors.indigoAccent
                                      : Colors.green),
                        ),
                      ],
                    ),
                    order.deliveryStatus == 'shipping'
                        ? Text(
                            'Estimated Delivey Date: ${_getFormattedDateFromFormattedString(value: order.deliveryDate, currentFormat: "yyyy-MM-ddTHH:mm:ssZ", desiredFormat: "yyyy-MM-dd").toString().split(' ')[0]}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.blue),
                          )
                        : const SizedBox.shrink(),
                    Row(
                      children: [
                        const Text(
                          'Order date: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _getFormattedDateFromFormattedString(
                                  value: order.orderDate,
                                  currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                  desiredFormat: "yyyy-MM-dd HH:mm:ss")
                              .toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    order.deliveryStatus == 'delivered'
                        ? const Text(
                            'This order has already been delivered.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                          )
                        : Row(
                            children: [
                              const Text(
                                'Change Delivery Status To: ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              order.deliveryStatus == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                          onConfirm: (date) async {
                                            await orderProvider.updateOrder(
                                                order.id, 'shipping', date);
                                          },
                                          theme: DatePickerTheme(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            cancelStyle: const TextStyle(
                                                color: Colors.red),
                                            doneStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                            itemStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Shipping?',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        await orderProvider.updateOrder(
                                            order.id, 'delivered', null);
                                      },
                                      child: const Text(
                                        'Delivered?',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                            ],
                          ),
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
