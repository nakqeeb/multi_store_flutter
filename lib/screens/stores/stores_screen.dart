import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:provider/provider.dart';

import '../../models/supplier.dart';
import '../../providers/auth_supplier_provider.dart';
import '../error/error_screen.dart';
import 'visit_store_screen.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  Future<List<Supplier>>? _suppliers;
  Supplier? _tempSupplier;
  @override
  void initState() {
    _suppliers = Provider.of<AuthSupplierProvider>(context, listen: false)
        .fetchSuppliers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: appLocale!.stores,
        ),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: _suppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingFour(
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const ErrorScreen(
                  title: 'Opps! Something went wrong',
                  subTitle: 'Please try to reload the application!');
            } else if (snapshot.data!.isNotEmpty) {
              snapshot.data!.shuffle();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => VisitStoreScreen(
                            supplier: snapshot.data![index].id == null
                                ? _tempSupplier!
                                : snapshot.data![index],
                          ),
                        ),
                      ).then((value) => setState(() {
                            _tempSupplier = snapshot.data![index];
                            snapshot.data![index] = value;
                          }));
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
                                child: Hero(
                                  key: ValueKey(
                                      snapshot.data![index].id.toString()),
                                  tag: snapshot.data![index].id.toString(),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'images/inapp/spinner.gif',
                                    image: snapshot.data![index].storeLogoUrl!,
                                    fit: BoxFit.cover,
                                  ),
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
              return const Center(
                child: Text(
                  'No stores!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme',
                      letterSpacing: 1.5),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No stores loaded!',
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
    );
  }
}
