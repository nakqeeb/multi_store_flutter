import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/screens/address/edit_address_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../error/error_screen.dart';
import 'custome_widget.dart';

class AddressTile extends StatefulWidget {
  final String addressId;
  final VoidCallback onPressed;
  final bool isDefault;
  const AddressTile(
      {Key? key,
      required this.addressId,
      required this.onPressed,
      this.isDefault = false})
      : super(key: key);

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  late Future<AddressData> _futureAddress;
  @override
  void initState() {
    print(widget.addressId);
    _futureAddress = Provider.of<AddressProvider>(context, listen: false)
        .fetchAddressById(widget.addressId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return FutureBuilder<AddressData>(
        future: _futureAddress,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              leading: const CustomWidget.circular(height: 64, width: 64),
              title: Align(
                alignment: Alignment.centerLeft,
                child: CustomWidget.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              subtitle: const CustomWidget.rectangular(height: 14),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const ErrorScreen(
                  title: 'Opps! Something went wrong',
                  subTitle: 'Please try to reload the application!');
            } else if (snapshot.data != null) {
              AddressData address = snapshot.data!;
              print(address.name);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: widget.isDefault == true ? null : widget.onPressed,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.isDefault == true
                          ? Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                address.name!.toUpperCase().toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              widget.isDefault == true
                                  ? const Icon(Icons.home)
                                  : const SizedBox.shrink(),
                              DropdownButton<String>(
                                icon: const Icon(Icons.more_vert),
                                underline: const SizedBox.shrink(),
                                isDense: true,
                                dropdownColor:
                                    Theme.of(context).colorScheme.primary,
                                items: <String>['Edit', 'Delete']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (theValue) async {
                                  if (theValue == 'Edit') {
                                    final response = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditAddressScreen(
                                                  address: address,
                                                )));
                                    if (response == true) {
                                      _futureAddress =
                                          addressProvider.fetchAddressById(
                                              address.id.toString());
                                    }
                                  } else if (theValue == 'Delete') {
                                    GlobalMethods.warningDialog(
                                      title: 'Delete address',
                                      subtitle:
                                          'Do you really want to delete this address?',
                                      fct: () async {
                                        await addressProvider
                                            .deleteAddress(widget.addressId);
                                      },
                                      context: context,
                                    );
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              '${address.address}, ${address.landmark}, ${address.city}, ${address.state} - ${address.pincode}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            address.phone.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              );
            } else if (snapshot.data == null) {
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
            return Center(child: Text('State: ${snapshot.connectionState}'));
          }
        });
  }
}
