import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app/components/product_grid_component_widget.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../error/error_screen.dart';

class GalleryTabScreen extends StatefulWidget {
  const GalleryTabScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<GalleryTabScreen> createState() => _GalleryTabScreenState();
}

class _GalleryTabScreenState extends State<GalleryTabScreen> {
  //List<Product> _products = [];
  late Future<List<Product>> _productsCategoryFuture;
  bool _isFavorite = false;

  currentCategoryProduct() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
    _productsCategoryFuture =
        productProvider.fetchProductsByCategoryId(widget.categoryId);
    /* _products = products
        .where((element) => element.mainCategory == widget.categoryId)
        .toList(); */
  }

  @override
  void initState() {
    print('This is category Id  ${widget.categoryId}');
    currentCategoryProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final productProvider = Provider.of<ProductProvider>(context);
    if (productProvider.isDeleted == true ||
        productProvider.isUpdated == true) {
      print('Product is Deleted');
      print('isDeleted == ${productProvider.isDeleted}');
      _productsCategoryFuture =
          productProvider.fetchProductsByCategoryId(widget.categoryId);
    }
    productProvider.isDeleted = false;
    productProvider.isUpdated = false;

    print('isDeleted == ${productProvider.isDeleted}');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return FutureBuilder<List<Product>>(
      future: _productsCategoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingFour(
            color: Theme.of(context).colorScheme.secondary,
            size: 35,
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorScreen(
                title: appLocale!.opps_went_wrong,
                subTitle: appLocale.try_to_reload_app);
          } else if (snapshot.data!.isNotEmpty) {
            List<Product> products =
                snapshot.data!.where((prod) => prod.inStock! > 0).toList();
            return SingleChildScrollView(
              child: MasonryGridView.count(
                itemCount: products.length,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductGridComponentWidget(
                    product: products[index],
                  );
                },
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                appLocale!.store_has_no_items_yet,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acme',
                    letterSpacing: 1.5),
              ),
            );
          } else {
            return Center(
              child: Text(
                appLocale!.no_products_loaded,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acme',
                    letterSpacing: 1.5),
              ),
            );
          }
        } else {
          return Center(child: Text('State: ${snapshot.connectionState}'));
        }
      },
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
