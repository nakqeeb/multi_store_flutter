import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/default_button.dart';
import '../../models/subcat.dart';
import '../../providers/category_provider.dart';
import '../../services/utils.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  bool _isinit = true;
  Product? _updatedProduct;

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

  Widget _previewTheCurrentImages() {
    if (_imagesUrlList.isNotEmpty) {
      return ListView.builder(
          itemCount: _imagesUrlList.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.network(_imagesUrlList[index]),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _imagesUrlList.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            );
          });
    } else {
      return const Center(
        child: Text('you have not \n \n picked images yet!',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );
    }
  }

  Widget _previewTheNewImages() {
    if (_imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: _imagesFileList!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.file(File(_imagesFileList![index].path)),
            );
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
        if (_imagesFileList!.isNotEmpty || _imagesUrlList.isNotEmpty) {
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

  Future<void> uploadData() async {
    if (_imagesUrlList.isNotEmpty) {
      Map updatedProduct = {
        'productName': _proName,
        'productDescription': _proDesc,
        'price': _price,
        'inStock': _quantity,
        'discount': _discount,
        'productImages': _imagesUrlList,
        'mainCategory': _mainCategValue!.id,
        'subCategory': _subCategValue!.id,
      };
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.productId, updatedProduct);

      // to pass it back to previous screen
      _updatedProduct = Product(
        id: widget.productId,
        productName: updatedProduct['productName'],
        productDescription: updatedProduct['productDescription'],
        price: updatedProduct['price'],
        inStock: updatedProduct['inStock'],
        discount: updatedProduct['discount'],
        productImages: updatedProduct['productImages'],
        mainCategory: updatedProduct['mainCategory'],
        subCategory: updatedProduct['subCategory'],
        supplier: context.read<AuthSupplierProvider>().supplier!.id,
      );
      setState(() {
        _isLoading = false;
        _imagesFileList = [];
        _mainCategValue = null;

        _subCategList = [];
        _imagesUrlList = [];
      });
      _formKey.currentState!.reset();
    } else {
      print('no images');
    }
  }

  Future<void> _uploadProduct() async {
    await uploadImages().whenComplete(() async => await uploadData());
  }

  Future<void> _deleteProduct() async {
    GlobalMethods.loadingDialog(title: 'Deleteing...', context: context);
    for (var image in _imagesUrlList) {
      try {
        await FirebaseStorage.instance.refFromURL(image).delete();
      } catch (err) {
        print(err);
      }
    }

    await Provider.of<ProductProvider>(context, listen: false)
        .deleteProduct(widget.productId);

    Navigator.pop(context);

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      final productProvider = Provider.of<ProductProvider>(context);
      await productProvider.fetchProductsById(widget.productId);
      final product = productProvider.product;
      final categories =
          Provider.of<CategoryProvider>(context, listen: false).categories;
      final mainCategory = categories
          .firstWhere((element) => element.id == product.mainCategory);
      _subCategList = mainCategory.subcategories!;
      final subcategory = mainCategory.subcategories!
          .firstWhere((element) => element.id == product.subCategory);
      print(subcategory.enSubName);
      _proName = product.productName!;
      _proDesc = product.productDescription!;
      _price = product.price!;
      _discount = product.discount;
      _quantity = product.inStock!;
      _mainCategValue = mainCategory;
      _subCategValue = subcategory;
      _imagesUrlList = product.productImages!;
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final categories = Provider.of<CategoryProvider>(context).categories;
    // to use snackBar, we need to wrap Scaffold with ScaffoldMessenger
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(
            title: 'Edit Product',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.red,
              tooltip: 'delete',
              onPressed: () async {
                await GlobalMethods.warningDialog(
                    title: 'Delete $_proName',
                    subtitle:
                        'Are you sure that you want to delete this product? ',
                    fct: () async {
                      await _deleteProduct();
                    },
                    context: context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, 'deleted');
                }
              },
            )
          ],
        ),
        body: _isinit
            ? SpinKitDoubleBounce(
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              )
            : SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  //reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
                              child: _imagesUrlList.isNotEmpty
                                  ? _previewTheCurrentImages()
                                  : Center(
                                      child: Text(
                                        'You have not \n\n picked any images yet!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: size.width * 0.5,
                              width: size.width * 0.5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                        dropdownColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        hint: const Text('select category'),
                                        value: _mainCategValue,
                                        items: categories
                                            .map<DropdownMenuItem<Category>>(
                                                (value) {
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
                                          iconDisabledColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          dropdownColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          menuMaxHeight: 500,
                                          hint:
                                              const Text('select subcategory'),
                                          value: _subCategValue,
                                          items: _subCategList.map<
                                              DropdownMenuItem<
                                                  Subcategory>>((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.enSubName.toString(),
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
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              height: size.width * 0.5,
                              width: size.width * 0.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.7),
                              child: _imagesFileList != null
                                  ? _previewTheNewImages()
                                  : Center(
                                      child: Text(
                                        'You have not \n\n picked any images yet!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    DefaultButton(
                                      onPressed: () async {
                                        _pickProductImages();
                                      },
                                      height: size.height * 0.05,
                                      width: size.width * 0.4,
                                      radius: 25,
                                      color: Colors.amber,
                                      widget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Pick up Images',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    _imagesFileList!.isEmpty
                                        ? const SizedBox.shrink()
                                        : DefaultButton(
                                            onPressed: () {
                                              setState(() {
                                                _imagesFileList!.clear();
                                              });
                                            },
                                            height: size.height * 0.05,
                                            width: size.width * 0.3,
                                            radius: 25,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            widget: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Reset',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
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
                                  initialValue: _price.toString(),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the price';
                                    } else if (value.isValidPrice() != true) {
                                      return 'Invalid price';
                                    }
                                    return null;
                                  },

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
                                  decoration:
                                      textFormDecoration(context).copyWith(
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
                                  initialValue: _discount.toString(),
                                  maxLength: 2,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return null;
                                    } else if (value.isValidDiscount() !=
                                        true) {
                                      return 'Invalid discount';
                                    }
                                    return null;
                                  },
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
                                  decoration:
                                      textFormDecoration(context).copyWith(
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
                              initialValue: _quantity.toString(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the quantity';
                                } else if (value.isValidQuantity() != true) {
                                  return 'shouldn\'t start with 0 (zero)';
                                }
                                return null;
                              },
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
                              initialValue: _proName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the product name';
                                }
                                return null;
                              },
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
                              initialValue: _proDesc,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the product description';
                                }
                                return null;
                              },
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
                        // cancel / saave buttons
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DefaultButton(
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                height: size.height * 0.06,
                                width: size.width * 0.3,
                                radius: 25,
                                color: Colors.red,
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DefaultButton(
                                onPressed: () async {
                                  // show the loading dialog
                                  GlobalMethods.loadingDialog(
                                      title: 'Updating...', context: context);
                                  await _uploadProduct();
                                  // Close the dialog programmatically
                                  Navigator.pop(context);

                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context, _updatedProduct);
                                  }
                                },
                                height: size.height * 0.06,
                                width: size.width * 0.5,
                                radius: 25,
                                color: Colors.green,
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Save The Changes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
