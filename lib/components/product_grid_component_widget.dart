import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:collection/collection.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/screens/edit_product/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../screens/product_details/product_details_screen.dart';

class ProductGridComponentWidget extends StatefulWidget {
  final Product product;
  const ProductGridComponentWidget({super.key, required this.product});

  @override
  State<ProductGridComponentWidget> createState() =>
      _ProductGridComponentWidgetState();
}

class _ProductGridComponentWidgetState
    extends State<ProductGridComponentWidget> {
  late Product _product;
  bool _isProcessing = false;
  @override
  void initState() {
    _product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authSupplierProvider = Provider.of<AuthSupplierProvider>(context);
    final supplier = authSupplierProvider.supplier;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final isOnSale = _product.discount! > 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: _product.id!,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  constraints:
                      const BoxConstraints(minHeight: 100, maxHeight: 250),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/inapp/product-placeholder.png',
                      image: _product.productImages!.first,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _product.productName.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '\$',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _product.price!.toStringAsFixed(2),
                                style: isOnSale
                                    ? TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough)
                                    : const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              isOnSale
                                  ? Text(
                                      ((1 - (_product.discount! / 100)) *
                                              _product.price!)
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          // necessary to use ? instead of ! to avoid the error when guest or customer is useing the app instead of supplier
                          _product.supplier == supplier?.id
                              ? IconButton(
                                  onPressed: () async {
                                    final response = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                          productId: _product.id!,
                                        ),
                                      ),
                                    );
                                    if (response == true) {
                                      setState(() {
                                        _product = productProvider.product;
                                      });
                                    } else if (response == false) {
                                      _product = Product();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                  ),
                                )
                              : !authSupplierProvider.isAuth
                                  ? (_isProcessing
                                      ? SizedBox(
                                          width: 50,
                                          height: 48,
                                          child: SpinKitPulse(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 25,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isProcessing = true;
                                            });
                                            var existingItemWishlist = context
                                                .read<WishlistProvider>()
                                                .wishlistProducts
                                                .firstWhereOrNull((product) =>
                                                    product.id ==
                                                    widget.product.id);

                                            existingItemWishlist != null
                                                ? await context
                                                    .read<WishlistProvider>()
                                                    .removeFromWishlist(widget
                                                        .product.id
                                                        .toString())
                                                : await context
                                                    .read<WishlistProvider>()
                                                    .addToWishlist(widget
                                                        .product.id
                                                        .toString());
                                            // to avoid error [FlutterError (setState() called after dispose(): (lifecycle state: defunct, not mounted)]
                                            if (!mounted) return;
                                            setState(() {
                                              _isProcessing = false;
                                            });
                                          },
                                          icon: context
                                                      .watch<WishlistProvider>()
                                                      .wishlistProducts
                                                      .firstWhereOrNull(
                                                          (product) =>
                                                              product.id ==
                                                              widget.product
                                                                  .id) !=
                                                  null
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 30,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                        ))
                                  : const SizedBox(
                                      height: 40,
                                    )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          isOnSale
              ? Positioned(
                  top: 30,
                  left: 0,
                  child: Container(
                    width: 80,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'save ${_product.discount}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
