import 'package:badges/badges.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:multi_store_app/models/cart_item.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/stores/visit_store_screen.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/product_grid_component_widget.dart';
import '../../services/utils.dart';
import '../cart/cart_screen.dart';
import 'components/full_screen_view.dart';
import 'components/product_details_header_label.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Supplier? _supplier; // to foreword it to VisitStoreScreen()
  bool _isLoading = false;
  bool isCustomerAuth = false;

  @override
  void initState() {
    isCustomerAuth = context.read<AuthCustomerProvider>().isAuth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> allProducts = productProvider.products;
    List<Product> similarProducts = allProducts
        .where((element) =>
            element.mainCategory == widget.product.mainCategory &&
            element.subCategory == widget.product.subCategory)
        .toList();
    similarProducts.removeWhere((element) => element.id == widget.product.id);
    final authSupplierProvider = Provider.of<AuthSupplierProvider>(context);
    final supplier = authSupplierProvider.supplier;
    final suppliers = authSupplierProvider.suppliers;
    final currentProductSuppliers = suppliers.firstWhere(
      (element) => element.id == widget.product.supplier,
    );
    // isCustomerAuth used with the cart to avoid error (Null check operator used on a null value) when supplier open the product

    final cartProvider = Provider.of<CartProvider>(context);
    Product? cartProduct;
    if (isCustomerAuth) {
      cartProduct = cartProvider.cart!.items!
          .firstWhere(
            (element) => element.cartProduct!.id == widget.product.id,
            orElse: () => CartItem(),
          )
          .cartProduct;
    }
    print("This is product in cart ${cartProduct?.productName}");
    return Material(
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
                          imagesList: widget.product.productImages!,
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
                              color: Theme.of(context).colorScheme.primary,
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          itemCount: widget.product.productImages!.length,
                          itemBuilder: (ctx, index) {
                            return FadeInImage.assetNetwork(
                              placeholder: 'images/inapp/ripple.gif',
                              image: widget.product.productImages![index],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 15,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : null;
                                  },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 15,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            onPressed: () {
                              print('Share');
                            },
                            icon: Icon(
                              Icons.share,
                              color: Theme.of(context).colorScheme.secondary,
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
                        widget.product.productName.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'USD ',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.product.price!.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // necessary to use ? instead of ! to avoid the error when guest or customer is useing the app instead of supplier
                          supplier?.id == widget.product.supplier
                              ? IconButton(
                                  onPressed: () {},
                                  tooltip: 'Edit',
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
                                    size: 30,
                                  ),
                                )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => VisitStoreScreen(
                                  supplier: currentProductSuppliers),
                            ),
                          );
                        },
                        child: Text(
                          'Seller: ${currentProductSuppliers.storeName}',
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
                        widget.product.inStock! <= 0
                            ? 'Out Of Stock'
                            : '${widget.product.inStock} pieces available in stock',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.7),
                        ),
                      ),
                      const ProductDetailsHeaderLabel(
                        label: 'Item Description',
                      ),
                      Text(
                        widget.product.productDescription.toString(),
                        textScaleFactor: 1.1,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      similarProducts.isNotEmpty
                          ? const ProductDetailsHeaderLabel(
                              label: 'Similar Items',
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
              : widget.product.inStock! <= 0
                  ? Container(
                      width: double.infinity,
                      height: size.height * 0.057,
                      color: Theme.of(context).colorScheme.tertiary,
                      child: const Center(
                        child: Text(
                          'OUT OF STOCK',
                          style: TextStyle(
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
                                        supplier: currentProductSuppliers),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.store,
                                color: Theme.of(context).colorScheme.primary,
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
                                    builder: (context) => const CartScreen(
                                      back: AppBarBackButton(),
                                    ),
                                  ),
                                );
                              },
                              tooltip: 'Cart',
                              icon: Consumer<AuthCustomerProvider>(
                                builder: (context, auth, child) => Badge(
                                  badgeColor:
                                      Theme.of(context).colorScheme.surface,
                                  badgeContent: !auth.isAuth
                                      ? const Text('0')
                                      : Text(cartProvider.cart!.items!.length
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
                                          .addToCart(widget.product.id!);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                          color: Theme.of(context).colorScheme.primary,
                          radius: 15,
                          widget: _isLoading
                              ? SpinKitFoldingCube(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 18,
                                )
                              : Text(
                                  cartProduct?.id != null
                                      ? 'ITEM IN CART'
                                      : 'ADD TO CART',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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