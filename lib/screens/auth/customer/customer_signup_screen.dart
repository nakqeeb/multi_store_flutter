import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/models/customer.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/screens/auth/customer/customer_login_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../../services/utils.dart';
import '../components/auth_header.dart';
import '../components/auth_main_button.dart';
import '../components/have_account.dart';
import '../auth_constants.dart';

class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  State<CustomerSignupScreen> createState() => _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen> {
  late String _name;
  late String _email;
  late String _password;
  late String _profileImageUrl;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isPasswordVisible = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void signup() async {
    FocusScope.of(context).unfocus();
    final appLocale = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          //check network availability
          var connectivityResult = await Connectivity().checkConnectivity();
          // check if the user is not connected to mobile network and wifi.
          if (connectivityResult != ConnectivityResult.mobile &&
              connectivityResult != ConnectivityResult.wifi) {
            GlobalMethods.showSnackBar(
                context, _scaffoldKey, appLocale!.noInternet);
            return;
          }
          // if there is internet then signup
          /* await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password); */
          // L49
          final ref = FirebaseStorage.instance
              .ref()
              .child('customers-images')
              .child('$_email.jpg');
          await ref.putFile(File(_imageFile!.path));
          _profileImageUrl = await ref.getDownloadURL();
          Customer newCustomer = Customer(
            name: _name,
            email: _email,
            profileImageUrl: _profileImageUrl,
            phone: '',
          );
          await Provider.of<AuthCustomerProvider>(context, listen: false)
              .signup(newCustomer, _password);

          GlobalMethods.successSignupDialog(
            context: context,
            title: appLocale!.success,
            subtitle: appLocale.account_created,
            doneBtn: appLocale.login_now,
            cancelBtn: appLocale.cancel,
            fct: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const CustomerLoginScreen(),
                ),
              );
            },
          );

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
        } catch (error) {
          print(error);
          GlobalMethods.showSnackBar(context, _scaffoldKey, error.toString());
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        GlobalMethods.showSnackBar(
            context, _scaffoldKey, appLocale!.pick_image);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Not valid');
      GlobalMethods.showSnackBar(
          context, _scaffoldKey, appLocale!.fill_all_fields);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    return ScaffoldMessenger(
      // to use snackBar, we need to wrap Scaffold with ScaffoldMessenger
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse:
                  true, // to show signup button in the screen when keyboard is openning
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthHeader(label: appLocale!.signup),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _pickImageFromCamera();
                                },
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Container(
                                  height: size.height * 0.055,
                                  width: size.width * 0.11,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  _pickImageFromGallery();
                                },
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                child: Container(
                                  height: size.height * 0.055,
                                  width: size.width * 0.11,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return appLocale.name_no_empty;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _name = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: appLocale.full_name,
                            hintText: appLocale.enter_full_name,
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.5)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return appLocale.email_is_required;
                            } else if (value.isValidEmail() == false) {
                              return appLocale.invalid_email;
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: appLocale.email,
                            hintText: appLocale.enter_email,
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.5)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          obscureText: _isPasswordVisible ? false : true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return appLocale.password_no_empty;
                            } else if (value.length < 6) {
                              return appLocale.password_six_char;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: appLocale.password,
                            hintText: appLocale.enter_password,
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.5)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      HaveAccount(
                        titleLabel: appLocale.alreadyHaveAccount,
                        btnLabel: appLocale.login,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const CustomerLoginScreen(),
                            ),
                          );
                        },
                      ),
                      _isLoading
                          ? SpinKitFoldingCube(
                              color: Theme.of(context).colorScheme.secondary,
                              size: 35,
                            )
                          : AuthMainButton(
                              label: appLocale.signup,
                              onPressed: () {
                                signup();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
