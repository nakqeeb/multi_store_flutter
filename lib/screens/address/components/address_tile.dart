import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/screens/address/edit_address_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_provider.dart';
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
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    return FutureBuilder<AddressData>(
        future: _futureAddress,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              leading: const CustomWidget.circular(height: 64, width: 64),
              title: Align(
                alignment:
                    isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: CustomWidget.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              subtitle: const CustomWidget.rectangular(height: 14),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorScreen(
                  title: appLocale!.opps_went_wrong,
                  subTitle: appLocale.try_to_reload_app);
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
                    padding: const EdgeInsets.all(10),
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
                              items: <String>[appLocale!.edit, appLocale.delete]
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: value == appLocale.delete
                                            ? Colors.red
                                            : null),
                                  ),
                                );
                              }).toList(),
                              onChanged: (theValue) async {
                                if (theValue == appLocale.edit) {
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
                                } else if (theValue == appLocale.delete) {
                                  print('delete');
                                  await GlobalMethods.warningDialog(
                                    title: appLocale.delete_address,
                                    subtitle: appLocale.do_you_delete_address,
                                    btnTitle: appLocale.yes,
                                    cancelBtn: appLocale.cancel,
                                    fct: () async {
                                      addressProvider
                                          .deleteAddress(widget.addressId);
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                      Fluttertoast.showToast(
                                        msg: appLocale.address_has_deleted,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                    context: context,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${address.address} - ${address.landmark} - ${address.city} - ${address.state} - ${address.pincode}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          address.phone.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.data == null) {
              return Center(
                child: Text(
                  appLocale!.no_address_yet,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acme',
                    letterSpacing: 1.5,
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  appLocale!.no_addresses_loaded,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
