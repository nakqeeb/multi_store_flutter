import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/app_bar_title.dart';
import '../../components/product_grid_component_widget.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../providers/category_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/product_provider.dart';

class SubCategoryProductsScreen extends StatefulWidget {
  final String maincategId;
  final String subcategId;
  const SubCategoryProductsScreen(
      {Key? key, required this.subcategId, required this.maincategId})
      : super(key: key);

  @override
  State<SubCategoryProductsScreen> createState() =>
      _SubCategoryProductsScreenState();
}

class _SubCategoryProductsScreenState extends State<SubCategoryProductsScreen> {
  List<Product> _products = [];
  bool _isFavorite = false;
  bool _isLoading = false;

  currentCategoryProduct() async {
    setState(() {
      _isLoading = true;
    });
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchProducts();
    List<Product> products = productProvider.products;
    /* for (int i = 0; i < products.length; i++) {
      if (products[i].mainCategory == widget.categoryId) {
        _products.add(products[i]);
      }
    } */
    setState(() {
      _products = products
          .where((element) => element.mainCategory == widget.maincategId)
          .where((element) => element.subCategory == widget.subcategId)
          .toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    print('This is category Id  ${widget.maincategId}');
    currentCategoryProduct();
    print('This is products length for current cat Id  ${_products.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    List<Category> categories = categoryProvider.categories;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: isArabic
              ? categories
                  .firstWhere((element) => element.id == widget.maincategId)
                  .subcategories!
                  .firstWhere((element) => element.id == widget.subcategId)
                  .arSubName
                  .toString()
              : categories
                  .firstWhere((element) => element.id == widget.maincategId)
                  .subcategories!
                  .firstWhere((element) => element.id == widget.subcategId)
                  .enSubName
                  .toString(),
        ),
        leading: const AppBarBackButton(),
      ),
      body: _isLoading
          ? SpinKitFadingFour(
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            )
          : _products.isEmpty
              ? Center(
                  child: Text(
                    appLocale!.category_no_item,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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

                      /* Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              minHeight: 100, maxHeight: 250),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _products[index].price!.toStringAsFixed(2) +
                                        (' \$'),
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
                  ); */
                    },
                  ),
                ),
    );
  }
}
