import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/models/supplier.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/stores/edit_store_screen.dart';
import 'package:multi_store_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../../components/product_grid_component_widget.dart';
import '../../providers/locale_provider.dart';
import '../error/error_screen.dart';

class VisitStoreScreen extends StatefulWidget {
  final Supplier supplier;
  const VisitStoreScreen({super.key, required this.supplier});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  Future<List<Product>>? _supplierProducts;
  Supplier? _supplier;
  bool _isFollowing = false;
  @override
  void initState() {
    _supplier = widget.supplier;
    _supplierProducts = Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsBySupplierId(widget.supplier.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final authSupplierProvider = Provider.of<AuthSupplierProvider>(context);
    final currentSupplier = authSupplierProvider.supplier;
    return WillPopScope(
      onWillPop: () async {
        Navigator.canPop(context) ? Navigator.pop(context, _supplier) : null;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 100,
          flexibleSpace:
              _supplier?.coverImageUrl == '' || _supplier?.coverImageUrl == null
                  ? Image.asset(
                      'images/inapp/coverimage.jpg',
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'images/inapp/coverimage.jpg',
                      image: _supplier?.coverImageUrl as String,
                      fit: BoxFit.cover,
                    ),
          title: Row(
            children: [
              Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Hero(
                    key: ValueKey(widget.supplier.id.toString()),
                    tag: widget.supplier.id.toString(),
                    child: _supplier?.storeLogoUrl == null
                        ? Image.asset('images/inapp/spinner.gif')
                        : FadeInImage.assetNetwork(
                            placeholder: 'images/inapp/spinner.gif',
                            image: _supplier!.storeLogoUrl.toString(),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _supplier!.storeName.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Acme',
                              fontSize: 24,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.supplier.id == currentSupplier?.id
                        ? Container(
                            height: 30,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    width: 3,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(25)),
                            child: MaterialButton(
                              onPressed: () async {
                                final response = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditStoreScreen(),
                                    ));
                                if (response == true) {
                                  _supplier = authSupplierProvider.supplier;
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    appLocale!.edit,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 30,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    width: 3,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(25)),
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                              },
                              child: _isFollowing == true
                                  ? Text(appLocale!.following,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary))
                                  : Text(appLocale!.follow,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary)),
                            ))
                  ],
                ),
              )
            ],
          ),
          leading: IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.canPop(context)
                  ? Navigator.pop(context, _supplier)
                  : null;
            },
          ),
        ),
        body: FutureBuilder<List<Product>>(
          future: _supplierProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitFadingFour(
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScreen(
                    title: appLocale.opps_went_wrong,
                    subTitle: appLocale.try_to_reload_app);
              } else if (snapshot.data!.isNotEmpty) {
                return SingleChildScrollView(
                  child: MasonryGridView.count(
                    itemCount: snapshot.data!.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.all(10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductGridComponentWidget(
                        product: snapshot.data![index],
                      );
                    },
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    appLocale.store_has_no_items_yet,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    appLocale.no_products_loaded,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
        ),
        floatingActionButton: widget.supplier.phone != ''
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {},
              )
            : null,
      ),
    );
  }
}
