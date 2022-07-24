import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:provider/provider.dart';

import '../screens/product_details/product_details_screen.dart';

class ProductGridComponentWidget extends StatefulWidget {
  const ProductGridComponentWidget({super.key, required this.product});
  final Product product;

  @override
  State<ProductGridComponentWidget> createState() =>
      _ProductGridComponentWidgetState();
}

class _ProductGridComponentWidgetState
    extends State<ProductGridComponentWidget> {
  @override
  Widget build(BuildContext context) {
    final supplier = Provider.of<AuthSupplierProvider>(context).supplier;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 250),
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
                      Text(
                        widget.product.price!.toStringAsFixed(2) + (' \$'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // necessary to use ? instead of ! to avoid the error when guest or customer is useing the app instead of supplier
                      widget.product.supplier == supplier?.id
                          ? IconButton(
                              onPressed: () {},
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
    );
  }
}
