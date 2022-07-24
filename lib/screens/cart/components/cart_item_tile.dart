import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/cart_item.dart';

class CartItemTile extends StatefulWidget {
  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  final CartItem cartItem;

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          child: SizedBox(
        height: 100,
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: FadeInImage.assetNetwork(
                placeholder: 'images/inapp/spinner.gif',
                placeholderFit: BoxFit.cover,
                image: widget.cartItem.cartProduct!.productImages!.first,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cartItem.cartProduct!.productName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.cartItem.cartProduct!.price!
                              .toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        _isLoading
                            ? Container(
                                height: 35,
                                width: 105,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SpinKitCircle(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              )
                            : Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    widget.cartItem.quantity == 1
                                        ? IconButton(
                                            onPressed: () async {
                                              await context
                                                  .read<CartProvider>()
                                                  .removeItem(widget.cartItem
                                                      .cartProduct!.id!);
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              size: 18,
                                            ))
                                        : IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              await context
                                                  .read<CartProvider>()
                                                  .reduceByOne(widget.cartItem
                                                      .cartProduct!.id!);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                            icon: const Icon(
                                              FontAwesomeIcons.minus,
                                              size: 18,
                                            )),
                                    Text(
                                      widget.cartItem.quantity.toString(),
                                      style: widget.cartItem.quantity ==
                                              widget
                                                  .cartItem.cartProduct!.inStock
                                          ? const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Acme',
                                              color: Colors.red,
                                            )
                                          : const TextStyle(
                                              fontSize: 20, fontFamily: 'Acme'),
                                    ),
                                    IconButton(
                                        onPressed: widget.cartItem.quantity ==
                                                widget.cartItem.cartProduct!
                                                    .inStock
                                            ? null
                                            : () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                await context
                                                    .read<CartProvider>()
                                                    .addToCart(
                                                        widget.cartItem
                                                            .cartProduct!.id!,
                                                        isCartPage: true);
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                        icon: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 18,
                                          color: widget.cartItem.quantity ==
                                                  widget.cartItem.cartProduct!
                                                      .inStock
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.3)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                        ))
                                  ],
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
