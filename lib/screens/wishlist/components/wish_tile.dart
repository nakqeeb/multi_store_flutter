import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class WishTile extends StatefulWidget {
  final Product product;
  const WishTile({super.key, required this.product});

  @override
  State<WishTile> createState() => _WishTileState();
}

class _WishTileState extends State<WishTile> {
  bool _isAddingToCart = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: SizedBox(
        height: 100,
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: FadeInImage.assetNetwork(
                placeholder: 'images/inapp/product-placeholder.png',
                image: widget.product.productImages!.first,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.productName!,
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
                          widget.product.price!.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<WishlistProvider>()
                                      .removeFromWishlist(widget.product.id!);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                )),
                            const SizedBox(width: 10),
                            context
                                            .watch<CartProvider>()
                                            .cart!
                                            .items!
                                            .firstWhereOrNull((element) =>
                                                element.cartProduct!.id ==
                                                widget.product.id) !=
                                        null ||
                                    widget.product.inStock == 0
                                ? const SizedBox.shrink()
                                : _isAddingToCart
                                    ? SizedBox(
                                        height: 30,
                                        width: 35,
                                        child: SpinKitCircle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 22,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isAddingToCart = true;
                                          });
                                          await context
                                              .read<CartProvider>()
                                              .addToCart(widget.product.id!);
                                          // to avoid error [FlutterError (setState() called after dispose(): (lifecycle state: defunct, not mounted)]
                                          if (!mounted) return;
                                          setState(() {
                                            _isAddingToCart = false;
                                          });
                                        },
                                        icon:
                                            const Icon(Icons.add_shopping_cart))
                          ],
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
