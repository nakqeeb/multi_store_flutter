import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/screens/address/components/address_tile.dart';
import 'package:multi_store_app/screens/address/edit_address_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../error/error_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Future<List<Address>> _futureAddresses;
  @override
  void initState() {
    _futureAddresses =
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final authCustomerProvider = Provider.of<AuthCustomerProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const AppBarTitle(
              title: 'Address Book',
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditAddressScreen()));
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                tooltip: 'Add address',
              )
            ],
          ),
          body: FutureBuilder<List<Address>>(
            future: _futureAddresses,
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
                  List<Address> addresses = snapshot.data!;
                  return ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) => AddressTile(
                      onPressed: () async {
                        GlobalMethods.loadingDialog(
                            title: 'Setting default...', context: context);
                        if (addresses[index].customerId ==
                            authCustomerProvider.customer!.id) {
                          for (int i = 0; i < addresses.length; i++) {
                            await addressProvider.updateAddress(
                                addresses[i].id.toString(),
                                {'isDefault': false});
                            addresses[i].isDefault = false;
                          }
                          await addressProvider
                              .fetchAddresses()
                              .then((value) async {
                            if (value[index].id == addresses[index].id) {
                              await addressProvider.updateAddress(
                                  addresses[index].id.toString(),
                                  {'isDefault': true});

                              await addressProvider.fetchAddresses();
                            }
                          });
                        }
                        setState(() {
                          addresses[index].isDefault = true;
                        });

                        // Close the dialog programmatically
                        Navigator.pop(context);
                      },
                      name: addresses[index].name.toString(),
                      phone: addresses[index].phone.toString(),
                      address: addresses[index].address.toString(),
                      landmark: addresses[index].landmark.toString(),
                      city: addresses[index].city.toString(),
                      state: addresses[index].state.toString(),
                      pincode: addresses[index].pincode.toString(),
                      isDefault: addresses[index].isDefault as bool,
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'You have not added any address yet!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No addresses loaded!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            },
          )),
    );
  }
}
