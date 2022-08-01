import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../models/subcat.dart';
import '../../providers/category_provider.dart';
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
    if (_imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: _imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(_imagesFileList![index].path));
          });
    } else {
      return const Center(
        child: Text('you have not \n \n picked images yet!',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
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
              context, _scaffoldKey, 'please pick images first');
        }
      } else {
        GlobalMethods.showSnackBar(
            context, _scaffoldKey, 'please fill all fields');
      }
    } else {
      GlobalMethods.showSnackBar(
          context, _scaffoldKey, 'please select category');
    }
  }

  void uploadData() async {
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
      // });
    } else {
      print('no images');
    }
  }

  void _uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
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
                                  'You have not \n\n picked any images yet!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                const Text(
                                  '* select main category',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DropdownButton<Category>(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor:
                                      Theme.of(context).colorScheme.primary,
                                  hint: const Text('select category'),
                                  value: _mainCategValue,
                                  items: categories
                                      .map<DropdownMenuItem<Category>>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value.enName.toString(),
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
                                const Text(
                                  '* select subcategory',
                                  style: TextStyle(color: Colors.red),
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
                                    hint: const Text('select subcategory'),
                                    value: _subCategValue,
                                    items: _subCategList
                                        .map<DropdownMenuItem<Subcategory>>(
                                            (value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.enSubName.toString(),
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
                                return 'Please enter the price';
                              } else if (value.isValidPrice() != true) {
                                return 'Invalid price';
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
                              labelText: 'Price',
                              hintText: 'Price.. \$',
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidDiscount() != true) {
                                return 'Invalid discount';
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
                              labelText: 'Discount',
                              hintText: 'discount.. %',
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
                            return 'Please enter the quantity';
                          } else if (value.isValidQuantity() != true) {
                            return 'shouldn\'t start with 0 (zero)';
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
                          labelText: 'Quantity',
                          hintText: 'Add quantity',
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
                            return 'Please enter the product name';
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
                            100, // this automatically will add a small coutner length underneeth TextFormField
                        maxLines: 3,
                        decoration: textFormDecoration(context).copyWith(
                          labelText: 'Product name',
                          hintText: 'Enter product name',
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
                            return 'Please enter the product description';
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
                          labelText: 'Product description',
                          hintText: 'Enter product description',
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
              padding: const EdgeInsets.only(right: 10),
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
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  _imagesFileList!.isEmpty
                      ? Icons.photo_library
                      : Icons.delete_forever,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                _uploadProduct();
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
