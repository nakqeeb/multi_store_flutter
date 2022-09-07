import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/following_store_provider.dart';
import 'package:multi_store_app/screens/stores/components/all_stores.dart';
import 'package:multi_store_app/screens/stores/components/following_stores.dart';
import 'package:multi_store_app/screens/stores/visit_store_screen.dart';
import 'package:provider/provider.dart';

import '../../models/supplier.dart';
import '../../providers/auth_supplier_provider.dart';
import '../error/error_screen.dart';

enum Filter { allStores, followingStores }

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  Filter defaultValue = Filter.allStores;
  bool _isInit = true;
  Future<List<Supplier>>? _suppliers;
  @override
  void initState() {
    _suppliers = Provider.of<AuthSupplierProvider>(context, listen: false)
        .fetchSuppliers();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    print('_isInit $_isInit');
    if (_isInit && context.read<AuthCustomerProvider>().isAuth) {
      await Provider.of<FollowingStoreProvider>(context).fetchFollowingStores();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final followingStoreProvider = Provider.of<FollowingStoreProvider>(context);
    print('_isInit $_isInit');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: appLocale!.stores,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            followingStoreProvider.followingStores.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        defaultValue == Filter.allStores
                            ? Text(
                                appLocale.all_stores,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'AkayaTelivigala',
                                ),
                              )
                            : Text(
                                appLocale.following_stores,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'AkayaTelivigala',
                                ),
                              ),
                        PopupMenuButton(
                          tooltip: 'Filter',
                          onSelected: (value) {
                            print(value);
                            setState(() {
                              defaultValue = value;
                            });
                            if (defaultValue == Filter.allStores) {
                              _suppliers = Provider.of<AuthSupplierProvider>(
                                      context,
                                      listen: false)
                                  .fetchSuppliers();
                            } else {
                              _suppliers = Provider.of<FollowingStoreProvider>(
                                      context,
                                      listen: false)
                                  .fetchFollowingStores();
                            }
                          },
                          icon: const Icon(
                            Icons.filter_alt,
                            size: 30,
                          ),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: Filter.allStores,
                              child: Text(appLocale.all_stores),
                            ),
                            PopupMenuItem(
                              value: Filter.followingStores,
                              child: Text(appLocale.following_stores),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            /* followingStoreProvider.followingStores.isNotEmpty
                ? const FollowingStores()
                : const SizedBox.shrink(), */
            /* defaultValue == Filter.allStores
                ? const AllStores()
                : const FollowingStores() */

            FutureBuilder<List<Supplier>>(
              future: _suppliers,
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
                    if (defaultValue == Filter.allStores) {
                      snapshot.data!.shuffle();
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => VisitStoreScreen(
                                  supplier: snapshot.data![index],
                                ),
                              ),
                            );
                            setState(() {
                              defaultValue = Filter.allStores;
                              _suppliers = Provider.of<AuthSupplierProvider>(
                                      context,
                                      listen: false)
                                  .fetchSuppliers();
                            });
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child:
                                        Image.asset('images/inapp/store.png'),
                                  ),
                                  Positioned(
                                    bottom: 27,
                                    left: 10,
                                    child: SizedBox(
                                      height: 48,
                                      width: 100,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'images/inapp/spinner.gif',
                                        image:
                                            snapshot.data![index].storeLogoUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                snapshot.data![index].storeName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontFamily: 'AkayaTelivigala'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        appLocale.no_stores_found,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Acme',
                            letterSpacing: 1.5),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        appLocale.no_stores_loaded,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Acme',
                            letterSpacing: 1.5),
                      ),
                    );
                  }
                } else {
                  return Center(
                      child: Text('State: ${snapshot.connectionState}'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
