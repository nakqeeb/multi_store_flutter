import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:multi_store_app/models/address.dart';
import 'package:multi_store_app/providers/address_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class EditAddressScreen extends StatefulWidget {
  AddressData? address;
  EditAddressScreen({super.key, this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name, _phone, _pincode, _address, _landmark, _city, _state;
  bool _isInit = true;

  Future<void> _editAddress() async {
    FocusScope.of(context).unfocus();
    final appLocale = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      GlobalMethods.loadingDialog(
          title: appLocale!.please_wait, context: context);
      if (widget.address == null) {
        AddressData newAddress = AddressData(
          name: _name!.trim(),
          phone: _phone,
          pincode: _pincode,
          address: _address!.trim(),
          landmark: _landmark!.trim(),
          city: _city!.trim(),
          state: _state!.trim(),
          isDefault: false,
        );
        await Provider.of<AddressProvider>(context, listen: false)
            .addAddress(newAddress);
      } else {
        Map updatedAddress = {
          'name': _name!.trim(),
          'phone': _phone,
          'pincode': _pincode,
          'address': _address!.trim(),
          'landmark': _landmark!.trim(),
          'city': _city!.trim(),
          'state': _state!.trim(),
        };
        await Provider.of<AddressProvider>(context, listen: false)
            .updateAddress(widget.address!.id.toString(), updatedAddress);
      }
      Navigator.pop(context);
      Navigator.canPop(context) ? Navigator.pop(context, true) : null;
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (widget.address == null) {
        _isInit = false;
        return;
      }
      _name = widget.address?.name;
      _phone = widget.address?.phone;
      _pincode = widget.address?.pincode;
      _address = widget.address?.address;
      _landmark = widget.address?.landmark;
      _city = widget.address?.city;
      _state = widget.address?.state;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: const AppBarBackButton(),
          title: AppBarTitle(title: appLocale!.edit_ddress),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: _name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return appLocale.fullname_required;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                      decoration: textFormDecoration(context).copyWith(
                        labelText: appLocale.full_name,
                        hintText: appLocale.enter_full_name,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            initialValue: _phone,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return appLocale.phone_required;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phone = value!;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.phone,
                              hintText: appLocale.enter_phone,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            initialValue: _pincode,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return appLocale.pincode_required;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _pincode = value!;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.pincode,
                              hintText: appLocale.enter_pincode,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            initialValue: _state,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return appLocale.province_required;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _state = value!;
                            },
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.province,
                              hintText: appLocale.enter_province,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            initialValue: _city,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return appLocale.city_required;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _city = value!;
                            },
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.city,
                              hintText: appLocale.enter_city,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: _address,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return appLocale.address_required;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _address = value!;
                      },
                      decoration: textFormDecoration(context).copyWith(
                        labelText: appLocale.address_house_building,
                        hintText: appLocale.enter_address,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: _landmark,
                      maxLines: 2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return appLocale.landmark_required;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _landmark = value!;
                      },
                      decoration: textFormDecoration(context).copyWith(
                        labelText: appLocale.landmark_road_area,
                        hintText: appLocale.enter_landmark,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 70, 8, 8),
                    child: DefaultButton(
                      onPressed: () async {
                        await _editAddress();
                      },
                      height: size.height * 0.06,
                      width: size.width * 0.7,
                      radius: 15,
                      color: Theme.of(context).colorScheme.secondary,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            appLocale.save_address,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration textFormDecoration(BuildContext context) {
    return InputDecoration(
      labelText: 'Full Name',
      hintText: 'Enter your full name',
      labelStyle:
          TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
