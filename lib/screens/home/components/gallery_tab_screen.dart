import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app/components/product_grid_component_widget.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class GalleryTabScreen extends StatefulWidget {
  const GalleryTabScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<GalleryTabScreen> createState() => _GalleryTabScreenState();
}

class _GalleryTabScreenState extends State<GalleryTabScreen> {
  List<Product> _products = [];
  bool _isFavorite = false;

  currentCategoryProduct() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
    List<Product> products = productProvider.products;
    /* for (int i = 0; i < products.length; i++) {
      if (products[i].mainCategory == widget.categoryId) {
        _products.add(products[i]);
      }
    } */
    _products = products
        .where((element) => element.mainCategory == widget.categoryId)
        .toList();
  }

  @override
  void initState() {
    print('This is category Id  ${widget.categoryId}');
    currentCategoryProduct();
    print('This is products length for current cat Id  ${_products.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _products.isEmpty
        ? const Center(
            child: Text(
              'This category \n\n has no items yet!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5),
            ),
          )
        : SingleChildScrollView(
            child: MasonryGridView.count(
              itemCount: _products.length,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ProductGridComponentWidget(
                  product: _products[index],
                );
              },
            ),
          );
  }

  /* Container gridComponent(BuildContext context, int index) {
    return Container(
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
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/inapp/spinner.gif',
                image: _products[index].productImages![0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  _products[index].productName.toString(),
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
                      _products[index].price!.toStringAsFixed(2) + (' \$'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        icon: Icon(
                          _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  } */
}
