/* import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/providers/following_store_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/supplier.dart';
import '../../../services/utils.dart';
import '../../error/error_screen.dart';
import '../visit_store_screen.dart';

class FollowingStores extends StatefulWidget {
  const FollowingStores({Key? key}) : super(key: key);

  @override
  State<FollowingStores> createState() => _FollowingStoresState();
}

class _FollowingStoresState extends State<FollowingStores> {
  Future<List<Supplier>>? _followingStores; // or Following suppliers
  Supplier? _tempFollowingStore;
  @override
  void initState() {
    _followingStores =
        Provider.of<FollowingStoreProvider>(context, listen: false)
            .fetchFollowingStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return FutureBuilder<List<Supplier>>(
      future: _followingStores,
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
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10),
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () async {
                    final response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => VisitStoreScreen(
                            supplier: snapshot.data![index].id == null
                                ? _tempFollowingStore!
                                : snapshot.data![index]),
                      ),
                    );
                    /* if (response['followingState'] == true) {
                            _followingStores =
                                Provider.of<FollowingStoreProvider>(context,
                                        listen: false)
                                    .fetchFollowingStores();
                            return;
                          } */
                    setState(() {
                      _tempFollowingStore = snapshot.data![index];
                      snapshot.data![index] = response;
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset('images/inapp/store.png'),
                          ),
                          Positioned(
                            bottom: 27,
                            left: 10,
                            child: SizedBox(
                              height: 48,
                              width: 100,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'images/inapp/spinner.gif',
                                image: snapshot.data![index].storeLogoUrl!,
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
                            fontSize: 26, fontFamily: 'AkayaTelivigala'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                appLocale!.no_stores_found,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5,
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                appLocale!.no_stores_loaded,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5,
                ),
              ),
            );
          }
        } else {
          return Center(child: Text('State: ${snapshot.connectionState}'));
        }
      },
    );
  }
}
 */