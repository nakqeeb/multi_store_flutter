import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/fetch_screen.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_provider.dart';
import '../../../services/utils.dart';
import '../components/auth_header.dart';
import '../components/auth_main_button.dart';
import '../components/have_account.dart';
import '../auth_constants.dart';
import 'supplier_signup_screen.dart';

class SupplierLoginScreen extends StatefulWidget {
  const SupplierLoginScreen({super.key});

  @override
  State<SupplierLoginScreen> createState() => _SupplierLoginScreenState();
}

class _SupplierLoginScreenState extends State<SupplierLoginScreen> {
  late String _email;
  late String _password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isPasswordVisible = false;

  void login() async {
    FocusScope.of(context).unfocus();
    final appLocale = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
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
        // Check first if account is being activated by the admin (will be done later)

        // if there is internet then login
        await Provider.of<AuthSupplierProvider>(context, listen: false)
            .login(_email, _password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => const FetchScreen(),
          ),
        );

        _formKey.currentState!.reset();
      } catch (error) {
        print(error);
        GlobalMethods.showSnackBar(context, _scaffoldKey, error.toString());
      } finally {
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
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return ScaffoldMessenger(
      // to use snackBar, we need to wrap Scaffold with ScaffoldMessenger
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                reverse:
                    true, // to show signup button in the screen when keyboard is openning
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthHeader(label: appLocale!.login),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            // style: const TextStyle(color: Colors.deepPurpleAccent),
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
                            //style: const TextStyle(color: Colors.deepPurpleAccent),
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
                        Align(
                          alignment: isArabic
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              appLocale.forgotPassword,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        HaveAccount(
                          titleLabel: appLocale.haveNoAccountYet,
                          btnLabel: appLocale.signup,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SupplierSignupScreen(),
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
                                label: appLocale.login,
                                onPressed: () {
                                  login();
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
      ),
    );
  }
}
