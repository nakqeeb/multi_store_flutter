import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      GlobalMethods.loadingDialog(title: 'Adding...', context: context);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: 'Edit Address'),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'full name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                    decoration: textFormDecoration(context).copyWith(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone is required';
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
                            labelText: 'Phone',
                            hintText: 'Enter your phone',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pincode is required.';
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
                            labelText: 'Pincode',
                            hintText: 'Enter pincode',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'State is required.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _state = value!;
                          },
                          decoration: textFormDecoration(context).copyWith(
                            labelText: 'State',
                            hintText: 'Enter State',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'city is required.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _city = value!;
                          },
                          decoration: textFormDecoration(context).copyWith(
                            labelText: 'City',
                            hintText: 'Enter city',
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
                        return 'address is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = value!;
                    },
                    decoration: textFormDecoration(context).copyWith(
                      labelText: 'Address, House No, Building Name',
                      hintText: 'Enter Address',
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
                        return 'landmark is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _landmark = value!;
                    },
                    decoration: textFormDecoration(context).copyWith(
                      labelText: 'Landmark, Road Name, Area',
                      hintText: 'Enter Landmark',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 70, 8, 8),
                  child: DefaultButton(
                    onPressed: () async {
                      await _editAddress();
                    },
                    height: size.height * 0.05,
                    width: size.width * 0.7,
                    radius: 15,
                    color: Theme.of(context).colorScheme.secondary,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.save),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Save Address',
                          style: TextStyle(
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
