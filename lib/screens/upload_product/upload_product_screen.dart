import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../models/subcat.dart';
import '../../providers/category_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/utils.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // late double _price;
  late num _price;
  late int _quantity;
  late String _proName;
  late String _proDesc;
  int? _discount = 0;
  Category? _mainCategValue;
  Subcategory? _subCategValue;
  List<Subcategory> _subCategList = [];
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  List<XFile>? _imagesFileList = [];
  List<String> _imagesUrlList = [];
  dynamic _pickedImageError;

  void _pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        _imagesFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget _previewImages() {
    final appLocale = AppLocalizations.of(context);
    if (_imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: _imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(_imagesFileList![index].path));
          });
    } else {
      return Center(
        child: Text(appLocale!.no_picked_images_yet,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      );
    }
  }

  void selectedMainCateg(Category? value) {
    if (value == null) {
      _subCategList = [];
    } else {
      /*  var subCatsOfCurrentCat =
          Provider.of<CategoryProvider>(context, listen: false)
              .categories
              .firstWhere((element) => element.id == value.id)
              .subcategories; */

      //print(subCatsOfCurrentCat!.first.enSubName);
      _subCategList = value.subcategories!;
    }
    print(value);
    setState(() {
      _mainCategValue = value;
      _subCategValue = null;
    });
  }

  Future<void> uploadImages() async {
    FocusScope.of(context).unfocus();
    final appLocale = AppLocalizations.of(context);
    if (_mainCategValue != null && _subCategValue != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_imagesFileList!.isNotEmpty) {
          setState(() {
            _isLoading = true;
          });
          try {
            for (var image in _imagesFileList!) {
              Reference ref = FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  _imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          GlobalMethods.showSnackBar(
              context, _scaffoldKey, appLocale!.pick_images_first);
        }
      } else {
        GlobalMethods.showSnackBar(
            context, _scaffoldKey, appLocale!.fill_all_fields);
      }
    } else {
      GlobalMethods.showSnackBar(
          context, _scaffoldKey, appLocale!.please_select_category);
    }
  }

  void uploadData() async {
    final appLocale = AppLocalizations.of(context);
    if (_imagesUrlList.isNotEmpty) {
      // CollectionReference productRef =
      //     FirebaseFirestore.instance.collection('products');

      // proId = const Uuid().v4();

      // await productRef.doc(proId).set({
      //   'proid': proId,
      //   'maincateg': _mainCategValue,
      //   'subcateg': _subCategValue,
      //   'price': _price,
      //   'instock': _quantity,
      //   'proname': _proName,
      //   'prodesc': _proDesc,
      //   'sid': FirebaseAuth.instance.currentUser!.uid,
      //   'proimages': _imagesUrlList,
      //   'discount': 0,
      // }).whenComplete(() {
      Product newProduct = Product(
        productName: _proName,
        productDescription: _proDesc,
        price: _price,
        inStock: _quantity,
        discount: _discount,
        productImages: _imagesUrlList,
        mainCategory: _mainCategValue!.id,
        subCategory: _subCategValue!.id,
      );
      await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(newProduct);
      setState(() {
        _isLoading = false;
        _imagesFileList = [];
        _mainCategValue = null;

        _subCategList = [];
        _imagesUrlList = [];
      });
      _formKey.currentState!.reset();

      Fluttertoast.showToast(
        msg: appLocale!.product_added_successfully,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // });
    } else {
      print('no images');
    }
  }

  Future<void> _uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final categories = Provider.of<CategoryProvider>(context).categories;
    // to use snackBar, we need to wrap Scaffold with ScaffoldMessenger
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.7),
                        child: _imagesFileList != null
                            ? _previewImages()
                            : Center(
                                child: Text(
                                  appLocale!.no_picked_images_yet,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '*${appLocale!.select_main_category}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                DropdownButton<Category>(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor:
                                      Theme.of(context).colorScheme.primary,
                                  hint: Text(
                                    appLocale.select_category,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  value: _mainCategValue,
                                  items: categories
                                      .map<DropdownMenuItem<Category>>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        isArabic
                                            ? value.arName.toString()
                                            : value.enName.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    print(value!.id);
                                    selectedMainCateg(value);
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '*${appLocale.select_subcategory}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: DropdownButton<Subcategory>(
                                    isExpanded:
                                        true, // to avoid overflowing RenderFlex error
                                    iconSize: 40,
                                    iconEnabledColor: Colors.red,
                                    iconDisabledColor:
                                        Theme.of(context).colorScheme.primary,
                                    dropdownColor:
                                        Theme.of(context).colorScheme.primary,
                                    menuMaxHeight: 500,
                                    hint: Text(
                                      appLocale.select_subcategory,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    value: _subCategValue,
                                    items: _subCategList
                                        .map<DropdownMenuItem<Subcategory>>(
                                            (value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                            isArabic
                                                ? value.arSubName.toString()
                                                : value.enSubName.toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        _subCategValue = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: Divider(
                      color: Theme.of(context).colorScheme.secondary,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: size.width * 0.38,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return appLocale.price_required;
                              } else if (value.isValidPrice() != true) {
                                return appLocale.invalid_price;
                              }
                              return null;
                            },
                            /* onChanged: (value) {
                              // I check here to avoid the error because we parse the value to double and when we empty the text field the application will carsh
                              // another approach to solve this error is by useing onSaved instead of onChanged
                              if (value.isNotEmpty) {
                                _price = double.parse(value);
                              }
                            }, */
                            onSaved: (value) {
                              _price = double.parse(value!);
                            },
                            keyboardType: TextInputType
                                .number, // this will convert the keyboard to number but still you will be able to add characters along with the numbers
                            inputFormatters: [
                              //FilteringTextInputFormatter.digitsOnly, // found the solution in stackoverflow
                              // r'(^\d*\.?\d{0,2})' working fine
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^([1-9][0-9]*)([\.]{0,1})([0-9]{0,2})')) // I added this regExp for number with decimal point
                            ],
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.price,
                              hintText: '${appLocale.price}.. \$',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: size.width * 0.38,
                          child: TextFormField(
                            maxLength: 2,
                            initialValue: _discount.toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidDiscount() != true) {
                                return appLocale.invalid_discount;
                              }
                              return null;
                            },
                            /* onChanged: (value) {
                              // I check here to avoid the error because we parse the value to double and when we empty the text field the application will carsh
                              // another approach to solve this error is by useing onSaved instead of onChanged
                              if (value.isNotEmpty) {
                                _price = double.parse(value);
                              }
                            }, */
                            onSaved: (value) {
                              _discount = int.parse(value!);
                            },
                            keyboardType: TextInputType
                                .number, // this will convert the keyboard to number but still you will be able to add characters along with the numbers
                            inputFormatters: [
                              //FilteringTextInputFormatter.digitsOnly, // found the solution in stackoverflow
                              // r'(^\d*\.?\d{0,2})' working fine
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^([1-9][0-9]*)([\.]{0,1})([0-9]{0,2})')) // I added this regExp for number with decimal point
                            ],
                            decoration: textFormDecoration(context).copyWith(
                              labelText: appLocale.discount,
                              hintText: '${appLocale.discount}.. %',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: size.width * 0.45,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return appLocale.quantity_is_required;
                          } else if (value.isValidQuantity() != true) {
                            return appLocale.no_start_with_zero;
                          }
                          return null;
                        },
                        /* onChanged: (value) {
                          // I check here to avoid the error because we parse the value to int and when we empty the text field the application will carsh
                          // another approach to solve this error is by useing onSaved instead of onChanged
                          if (value.isNotEmpty) {
                            _quantity = int.parse(value);
                          }
                        }, */
                        onSaved: (value) {
                          _quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: textFormDecoration(context).copyWith(
                          labelText: appLocale.quantity,
                          hintText: appLocale.add_quantity,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return appLocale.product_name_required;
                          }
                          return null;
                        },
                        /* onChanged: (value) {
                          _proName = value;
                        }, */
                        onSaved: (value) {
                          _proName = value!;
                        },
                        maxLength:
                            150, // this automatically will add a small coutner length underneeth TextFormField
                        maxLines: 3,
                        decoration: textFormDecoration(context).copyWith(
                          labelText: appLocale.product_name,
                          hintText: appLocale.enter_product_name,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return appLocale.product_description_required;
                          }
                          return null;
                        },
                        /* onChanged: (value) {
                          _proDesc = value;
                        }, */
                        onSaved: (value) {
                          _proDesc = value!;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: textFormDecoration(context).copyWith(
                          labelText: appLocale.product_description,
                          hintText: appLocale.enter_product_description,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: FloatingActionButton(
                onPressed: () {
                  if (_imagesFileList!.isEmpty) {
                    _pickProductImages();
                  } else {
                    setState(() {
                      _imagesFileList!.clear();
                    });
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                child: Icon(
                  _imagesFileList!.isEmpty
                      ? Icons.photo_library
                      : Icons.delete_forever,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                GlobalMethods.loadingDialog(
                    context: context, title: appLocale.please_wait);
                await _uploadProduct();
                Navigator.pop(context);
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: _isLoading
                  ? SpinKitFoldingCube(
                      color: Theme.of(context).colorScheme.primary,
                      size: 35,
                    )
                  : Icon(
                      Icons.upload,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFormDecoration(BuildContext context) => InputDecoration(
        /* labelText: 'Price',
        hintText: 'Price.. \$', */
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

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
