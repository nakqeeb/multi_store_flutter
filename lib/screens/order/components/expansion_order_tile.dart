import 'package:flutter/material.dart';
import 'package:multi_store_app/models/order.dart';

import '../../../services/utils.dart';

class ExpansionOrderTile extends StatelessWidget {
  final Order order;
  const ExpansionOrderTile({super.key, required this.order});

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
                  image: order.product!.productImages![0],
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
                          order.product!.productName.toString(),
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
                              order.product!.price!.toStringAsFixed(2),
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
                order.deliveryStatus.toString(),
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7)),
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
                      'Name: ${order.customer?.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Phone No: ${order.customer?.phone}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Email: ${order.customer?.email}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Address: ${order.customer?.address}',
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
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    order.deliveryStatus == 'shipping'
                        ? Text(
                            'Estimated Delivey Date: ${order.deliveryDate}',
                            style: const TextStyle(fontSize: 15),
                          )
                        : const SizedBox.shrink(), // const Text(''),
                    order.deliveryStatus == 'delivered' &&
                            order.orderReview == false
                        ? TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Write Review',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(), // const Text(''),
                    order.deliveryStatus == 'delivered' &&
                            order.orderReview == true
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