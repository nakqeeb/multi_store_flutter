import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/screens/edit_product/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../screens/product_details/product_details_screen.dart';

class ProductGridComponentWidget extends StatefulWidget {
  Product product;
  ProductGridComponentWidget({super.key, required this.product});

  @override
  State<ProductGridComponentWidget> createState() =>
      _ProductGridComponentWidgetState();
}

class _ProductGridComponentWidgetState
    extends State<ProductGridComponentWidget> {
  @override
  Widget build(BuildContext context) {
    final supplier = Provider.of<AuthSupplierProvider>(context).supplier;
    final isOnSale = widget.product.discount! > 0;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: widget.product.id!,
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
                      placeholder: 'images/inapp/spinner.gif',
                      image: widget.product.productImages![0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.product.productName.toString(),
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
                                widget.product.price!.toStringAsFixed(2),
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
                                      ((1 - (widget.product.discount! / 100)) *
                                              widget.product.price!)
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
                          widget.product.supplier == supplier?.id
                              ? IconButton(
                                  onPressed: () async {
                                    final response = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                          productId: widget.product.id!,
                                        ),
                                      ),
                                    );
                                    if (response == 'deleted') {
                                      return;
                                    } else if (response != null) {
                                      setState(() {
                                        widget.product = response;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.red,
                                  ),
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
                        'save ${widget.product.discount}%',
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
