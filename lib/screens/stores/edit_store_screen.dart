import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:multi_store_app/models/supplier.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_supplier_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/utils.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFileLogo, _imageFileCover;
  dynamic _pickedImageError;
  late String _storeName;
  late String _phone;
  late String _storeLogoUrl;
  late String _storeCoverUrl;
  Supplier? _updatedSupplier;

  _pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  _pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFileCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future _uploadStoreLogo(Supplier supplier) async {
    if (_imageFileLogo != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('suppliers-images')
            .child('${supplier.email}supplier.jpg');
        await ref.putFile(File(_imageFileLogo!.path));
        _storeLogoUrl = await ref.getDownloadURL();
      } catch (err) {
        print(err);
      }
    } else {
      _storeLogoUrl = supplier.storeLogoUrl!;
    }
  }

  Future _uploadStoreCover(Supplier supplier) async {
    if (_imageFileCover != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('suppliers-images')
            .child('${supplier.email}supplier-cover.jpg');
        await ref.putFile(File(_imageFileCover!.path));
        _storeCoverUrl = await ref.getDownloadURL();
      } catch (err) {
        print(err);
      }
    } else {
      _storeCoverUrl = supplier.coverImageUrl!;
    }
  }

  Future _saveChanges(Supplier supplier) async {
    final appLocale = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // save data into the variable

      await _uploadStoreLogo(supplier).whenComplete(
        () async => await _uploadStoreCover(supplier).whenComplete(
          () async {
            Supplier updatedSupplier = Supplier(
              storeName: _storeName,
              storeLogoUrl: _storeLogoUrl,
              phone: _phone,
              coverImageUrl: _storeCoverUrl,
            );
            await Provider.of<AuthSupplierProvider>(context, listen: false)
                .updateStoreInfo(updatedSupplier);
            setState(() {
              _updatedSupplier = updatedSupplier;
            });
          },
        ),
      );
      setState(() {
        _imageFileLogo = null;
        _imageFileCover = null;
        _storeLogoUrl = '';
        _storeCoverUrl = '';
      });
      Fluttertoast.showToast(
        msg: appLocale!.store_updated_successfully,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      GlobalMethods.showSnackBar(
          context, _scaffoldKey, appLocale!.fill_all_fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final supplier = Provider.of<AuthSupplierProvider>(context).supplier;
    return WillPopScope(
      onWillPop: () async {
        Navigator.canPop(context) ? Navigator.pop(context, true) : null;
        return true;
      },
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.pop(context, true)
                      : null;
                },
              ),
              title: AppBarTitle(
                title: appLocale!.edit_store,
              ),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Store logo image
                      Column(
                        children: [
                          Text(
                            appLocale.store_logo,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: size.height * 0.09,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.network(
                                    supplier!.storeLogoUrl.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  DefaultButton(
                                    onPressed: () {
                                      _pickStoreLogo();
                                    },
                                    height: size.height * 0.05,
                                    width: size.width * 0.2,
                                    radius: 25,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    widget: Text(
                                      appLocale.change,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  _imageFileLogo == null
                                      ? const SizedBox.shrink()
                                      : DefaultButton(
                                          onPressed: () {
                                            setState(() {
                                              _imageFileLogo = null;
                                            });
                                          },
                                          height: size.height * 0.05,
                                          width: size.width * 0.2,
                                          radius: 25,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          widget: Text(
                                            appLocale.reset,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              _imageFileLogo == null
                                  ? const SizedBox.shrink()
                                  : Container(
                                      height: size.height * 0.09,
                                      width: size.width * 0.3,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 4,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: Image.file(
                                          File(_imageFileLogo!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Divider(
                              color: Theme.of(context).colorScheme.secondary,
                              thickness: 2.5,
                            ),
                          )
                        ],
                      ),

                      // Store Cover image
                      Column(
                        children: [
                          Text(
                            appLocale.cover_image,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: size.height * 0.09,
                                width: size.width * 0.35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: supplier.coverImageUrl == ''
                                      ? Image.asset(
                                          'images/inapp/coverimage.jpg',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          supplier.coverImageUrl.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Column(
                                children: [
                                  DefaultButton(
                                    onPressed: () {
                                      _pickCoverImage();
                                    },
                                    height: size.height * 0.05,
                                    width: size.width * 0.2,
                                    radius: 25,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    widget: Text(
                                      appLocale.change,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  _imageFileCover == null
                                      ? const SizedBox.shrink()
                                      : DefaultButton(
                                          onPressed: () {
                                            setState(() {
                                              _imageFileCover = null;
                                            });
                                          },
                                          height: size.height * 0.05,
                                          width: size.width * 0.2,
                                          radius: 25,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          widget: Text(
                                            appLocale.reset,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              _imageFileCover == null
                                  ? const SizedBox.shrink()
                                  : Container(
                                      height: size.height * 0.09,
                                      width: size.width * 0.35,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 4,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: Image.file(
                                          File(_imageFileCover!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Divider(
                              color: Theme.of(context).colorScheme.secondary,
                              thickness: 2.5,
                            ),
                          )
                        ],
                      ),

                      // Store name field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: supplier.storeName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return appLocale.store_no_empty;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _storeName = value!;
                          },
                          decoration: textFormDecoration(context).copyWith(
                            labelText: appLocale.store_name,
                            hintText: appLocale.enter_store_name,
                          ),
                        ),
                      ),

                      // Phone number field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: supplier.phone,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _phone = value!;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: textFormDecoration(context).copyWith(
                            labelText: appLocale.phone,
                            hintText: appLocale.enter_phone_whatsApp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Text(
                          '*${appLocale.warn_msg_for_store_phone}',
                          style: const TextStyle(
                              color: Colors.pinkAccent, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      // cancel / saave buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DefaultButton(
                            onPressed: () {
                              Navigator.canPop(context)
                                  ? Navigator.pop(context, true)
                                  : null;
                            },
                            height: size.height * 0.06,
                            width: size.width * 0.3,
                            radius: 25,
                            color: Colors.red,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  appLocale.cancel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DefaultButton(
                            onPressed: () async {
                              // show the loading dialog
                              showDialog(
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      // The background color
                                      // backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SpinKitDoubleBounce(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 45,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            // Some text
                                            Text(
                                              appLocale.updating,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                              await _saveChanges(supplier);
                              // Close the dialog programmatically
                              Navigator.of(context).pop();
                            },
                            height: size.height * 0.06,
                            width: size.width * 0.5,
                            radius: 25,
                            color: Colors.green,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  appLocale.save_changes,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  InputDecoration textFormDecoration(BuildContext context) => InputDecoration(
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        hintStyle: TextStyle(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      );
}
