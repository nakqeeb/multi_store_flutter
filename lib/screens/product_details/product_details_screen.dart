import 'package:badges/badges.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:multi_store_app/models/cart_item.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/product_details/components/average_rating_bar.dart';
import 'package:multi_store_app/screens/product_details/components/show_reviews.dart';
import 'package:multi_store_app/screens/stores/visit_store_screen.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/product_grid_component_widget.dart';
import '../../models/supplier.dart';
import '../../providers/locale_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../cart/cart_screen.dart';
import '../edit_product/edit_product_screen.dart';
import '../welcome/welcome_screen.dart';
import 'components/full_screen_view.dart';
import 'components/product_details_header_label.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Supplier? _supplier; // to foreword it to VisitStoreScreen()
  late Product _product;
  bool _isLoading = false;
  bool isCustomerAuth = false;
  bool _isInit = true;
  Product? cartProduct;
  late bool isOnSale;
  late List<Supplier> suppliers;
  Supplier? supplier;
  late Supplier currentProductSupplier;
  late List<Product> similarProducts;
  // _isProcessing for wishlist
  bool _isProcessing = false;

  @override
  void initState() {
    isCustomerAuth = context.read<AuthCustomerProvider>().isAuth;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final authSupplierProvider =
          Provider.of<AuthSupplierProvider>(context, listen: false);
      await productProvider.fetchProductsById(widget.productId);
      _product = productProvider.product;
      await authSupplierProvider.fetchProductSupplierById(_product.supplier!);
      currentProductSupplier = authSupplierProvider.productSupplier!;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> allProducts = productProvider.products;
    final cartProvider = Provider.of<CartProvider>(context);
    final authSupplierProvider = Provider.of<AuthSupplierProvider>(context);
    if (_isInit == false) {
      similarProducts = allProducts
          .where((element) =>
              element.mainCategory == _product.mainCategory &&
              element.subCategory == _product.subCategory)
          .toList();
      similarProducts.removeWhere((element) => element.id == _product.id);
      supplier = authSupplierProvider.supplier;
      suppliers = authSupplierProvider.suppliers;
      // isCustomerAuth used with the cart to avoid error (Null check operator used on a null value) when supplier open the product

      if (isCustomerAuth) {
        cartProduct = cartProvider.cart!.items!
            .firstWhere(
              (element) => element.cartProduct!.id == _product.id,
              orElse: () => CartItem(),
            )
            .cartProduct;
      }
      print("This is product in cart ${cartProduct?.productName}");
      isOnSale = _product.discount! > 0;
    }
    return _isInit
        ? Scaffold(
            body: SpinKitChasingDots(
            color: Theme.of(context).colorScheme.secondary,
            size: 35,
          ))
        : Material(
            // Material to not prevent notification bar to has a black background color
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                imagesList: _product.productImages!,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              height: size.height * 0.45,
                              child: Swiper(
                                pagination: SwiperPagination(
                                  margin: const EdgeInsets.all(5.0),
                                  builder: DotSwiperPaginationBuilder(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                itemCount: _product.productImages!.length,
                                itemBuilder: (ctx, index) {
                                  return FadeInImage.assetNetwork(
                                    placeholder: 'images/inapp/ripple.gif',
                                    image: _product.productImages![index],
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: isArabic ? null : 15,
                              right: isArabic ? 15 : null,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : null;
                                  },
                                  icon: Icon(
                                    isArabic
                                        ? Icons.arrow_back_ios
                                        : Icons.arrow_back_ios_new,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: isArabic ? null : 15,
                              left: isArabic ? 15 : null,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  onPressed: () {
                                    print('Share');
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            8, 8, 8, kBottomNavigationBarHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _product.productName.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                              child: AverageRatingBar(
                                  productId: _product.id.toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${appLocale!.usd} ',
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 20,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.lineThrough)
                                          : const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20,
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
                                              color: Colors.redAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                // necessary to use ? instead of ! to avoid the error when guest or customer is useing the app instead of supplier
                                supplier?.id == _product.supplier
                                    ? IconButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductScreen(
                                                productId: _product.id!,
                                              ),
                                            ),
                                          );

                                          if (productProvider.isDeleted ==
                                              true) {
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          } else if (productProvider
                                                  .isUpdated ==
                                              true) {
                                            await productProvider
                                                .fetchProductsById(
                                                    widget.productId);
                                            _product = productProvider.product;
                                          }
                                        },
                                        tooltip: appLocale.edit,
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
                                                  if (isCustomerAuth) {
                                                    setState(() {
                                                      _isProcessing = true;
                                                    });
                                                    var existingItemWishlist =
                                                        context
                                                            .read<
                                                                WishlistProvider>()
                                                            .wishlistProducts
                                                            .firstWhereOrNull(
                                                                (prod) =>
                                                                    prod.id ==
                                                                    _product
                                                                        .id);

                                                    existingItemWishlist != null
                                                        ? await context
                                                            .read<
                                                                WishlistProvider>()
                                                            .removeFromWishlist(
                                                                _product.id
                                                                    .toString())
                                                        : await context
                                                            .read<
                                                                WishlistProvider>()
                                                            .addToWishlist(
                                                                _product.id
                                                                    .toString());
                                                    // to avoid error [FlutterError (setState() called after dispose(): (lifecycle state: defunct, not mounted)]
                                                    if (!mounted) return;
                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                  } else {
                                                    GlobalMethods.warningDialog(
                                                      title: appLocale.login,
                                                      subtitle:
                                                          appLocale.login_first,
                                                      btnTitle: appLocale.login,
                                                      cancelBtn:
                                                          appLocale.cancel,
                                                      fct: () {
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                const WelcomeScreen(),
                                                          ),
                                                        );
                                                      },
                                                      context: context,
                                                    );
                                                  }
                                                },
                                                icon: context
                                                            .watch<
                                                                WishlistProvider>()
                                                            .wishlistProducts
                                                            .firstWhereOrNull(
                                                                (prod) =>
                                                                    prod.id ==
                                                                    _product
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
                                          ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => VisitStoreScreen(
                                        supplier: currentProductSupplier),
                                  ),
                                );
                              },
                              child: Text(
                                '${appLocale.seller}: ${currentProductSupplier.storeName}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              _product.inStock! <= 0
                                  ? appLocale.out_of_stock
                                  : '${_product.inStock} ${appLocale.pieces_available}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.7),
                              ),
                            ),
                            ProductDetailsHeaderLabel(
                              label: appLocale.item_description,
                            ),
                            Text(
                              _product.productDescription.toString(),
                              textScaleFactor: 1.1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            ExpandableTheme(
                              data: ExpandableThemeData(
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                iconSize: 24,
                                iconPadding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              child: ShowReviews(
                                productId: _product.id!,
                              ),
                            ),
                            similarProducts.isNotEmpty
                                ? ProductDetailsHeaderLabel(
                                    label: appLocale.similar_items,
                                  )
                                : Container(),
                            MasonryGridView.count(
                              itemCount: similarProducts.length,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              padding: const EdgeInsets.all(10),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductGridComponentWidget(
                                  product: similarProducts[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: !isCustomerAuth
                    ? null
                    : _product.inStock! <= 0
                        ? Container(
                            width: double.infinity,
                            height: size.height * 0.057,
                            color: Theme.of(context).colorScheme.tertiary,
                            child: Center(
                              child: Text(
                                appLocale.out_of_stock,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => VisitStoreScreen(
                                              supplier: currentProductSupplier),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.store,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                            back: AppBarBackButton(),
                                          ),
                                        ),
                                      );
                                    },
                                    tooltip: appLocale.cart,
                                    icon: Consumer<AuthCustomerProvider>(
                                      builder: (context, auth, child) => Badge(
                                        badgeColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        badgeContent: !auth.isAuth
                                            ? const Text('0')
                                            : Text(cartProvider
                                                .cart!.items!.length
                                                .toString()),
                                        child: Icon(Icons.shopping_cart,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              DefaultButton(
                                width: size.width * 0.55,
                                height: size.height * 0.057,
                                onPressed: cartProduct?.id != null
                                    ? null
                                    : _isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await cartProvider
                                                .addToCart(_product.id!);
                                            // to avoid error [FlutterError (setState() called after dispose(): (lifecycle state: defunct, not mounted)]
                                            if (!mounted) return;
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                color: Theme.of(context).colorScheme.primary,
                                radius: 15,
                                widget: _isLoading
                                    ? SpinKitFoldingCube(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 18,
                                      )
                                    : Text(
                                        cartProduct?.id != null
                                            ? appLocale.item_in_cart
                                            : appLocale.add_to_cart,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              )
                            ],
                          ),
              ),
            ),
          );
  }
}
