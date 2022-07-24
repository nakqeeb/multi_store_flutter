import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/bottom_bar/supplier_bottom_bar.dart';
import 'package:multi_store_app/fetch_screen.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

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
              context, _scaffoldKey, 'Please check your internet connection.');
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
          context, _scaffoldKey, 'Please fill all fields');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
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
                      const AuthHeader(label: 'Login'),
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
                              return 'Email address is required';
                            } else if (value.isValidEmail() == false) {
                              return 'Invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
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
                              return 'Password field can not be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Password',
                            hintText: 'Enter your password',
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
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      HaveAccount(
                        titleLabel: 'Don\'t have account?',
                        btnLabel: 'Sign Up',
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
                              label: 'Login',
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
    );
  }
}
