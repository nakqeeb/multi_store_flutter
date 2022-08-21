import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/components/default_button.dart';

import '../../services/utils.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'full name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {},
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {},
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pincode is required.';
                            }
                            return null;
                          },
                          onSaved: (value) {},
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'State is required.';
                            }
                            return null;
                          },
                          onSaved: (value) {},
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'city is required.';
                            }
                            return null;
                          },
                          onSaved: (value) {},
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
                    maxLines: 3,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'address is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    decoration: textFormDecoration(context).copyWith(
                      labelText: 'Address, House No, Building Name',
                      hintText: 'Enter Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    maxLines: 2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'landmark is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    decoration: textFormDecoration(context).copyWith(
                      labelText: 'Landmark, Road Name, Area',
                      hintText: 'Enter Landmark',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 70, 8, 8),
                  child: DefaultButton(
                    onPressed: () {},
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
