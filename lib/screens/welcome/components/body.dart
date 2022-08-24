import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_store_app/bottom_bar/customer_bottom_bar.dart';
import 'package:multi_store_app/components/default_button.dart';
import 'package:multi_store_app/screens/auth/customer/customer_login_screen.dart';
import 'package:multi_store_app/screens/auth/customer/customer_signup_screen.dart';
import 'package:multi_store_app/screens/auth/supplier/supplier_login_screen.dart';
import 'package:multi_store_app/screens/auth/supplier/supplier_signup_screen.dart';
import 'package:multi_store_app/screens/welcome/components/animated_logo.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_provider.dart';
import '../../../services/utils.dart';
import 'google_facebook_login.dart';

const textColors = [
  Color(0xFF79f7fb),
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal
];

const textStyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final appLocale = AppLocalizations.of(context);
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/inapp/bgimage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* const Text(
              'WELCOME',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ), */
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  appLocale!.welcome,
                  textStyle: textStyle,
                  colors: textColors,
                ),
                ColorizeAnimatedText(
                  appLocale.app_name,
                  textStyle: textStyle,
                  colors: textColors,
                )
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
            const SizedBox(
              height: 120,
              width: 200,
              child: Image(
                image: AssetImage('images/inapp/logo_dark.png'),
              ),
            ),
            SizedBox(
              height: 80,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF79f7fb),
                    fontFamily: 'Acme'),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText(appLocale.buy),
                    RotateAnimatedText(appLocale.shop),
                    RotateAnimatedText(appLocale.app_name),
                  ],
                  repeatForever: true,
                ),
              ),
            ),
            Align(
              alignment:
                  isArabic ? Alignment.centerLeft : Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: isArabic
                          ? const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        appLocale.suppliers_only,
                        style: const TextStyle(
                          color: Color(0xFF79f7fb),
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 60,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: isArabic
                          ? const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedLogo(
                          controller: _animationController,
                        ),
                        DefaultButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SupplierLoginScreen(),
                              ),
                            );
                          },
                          height: size.height * 0.06,
                          width:
                              isArabic ? size.width * 0.3 : size.width * 0.25,
                          radius: 50,
                          color: const Color(0xFF79f7fb),
                          widget: Text(
                            appLocale.login,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1c2732),
                            ),
                          ),
                        ),
                        DefaultButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SupplierSignupScreen(),
                              ),
                            );
                          },
                          height: size.height * 0.06,
                          width: size.width * 0.25,
                          radius: 50,
                          color: const Color(0xFF79f7fb),
                          widget: Text(
                            appLocale.signup,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1c2732),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment:
                  isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                height: 60,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: isArabic
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DefaultButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const CustomerLoginScreen(),
                          ),
                        );
                      },
                      height: size.height * 0.06,
                      width: isArabic ? size.width * 0.30 : size.width * 0.25,
                      radius: 50,
                      color: const Color(0xFF79f7fb),
                      widget: Text(
                        appLocale.login,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1c2732),
                        ),
                      ),
                    ),
                    DefaultButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const CustomerSignupScreen(),
                          ),
                        );
                      },
                      height: size.height * 0.06,
                      width: size.width * 0.25,
                      radius: 50,
                      color: const Color(0xFF79f7fb),
                      widget: Text(
                        appLocale.signup,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1c2732),
                        ),
                      ),
                    ),
                    AnimatedLogo(
                      controller: _animationController,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /* GoogleFacebookLogIn(
                      label: 'Google',
                      onPresssed: () {},
                      child: const Image(
                          image: AssetImage('images/inapp/google.jpg')),
                    ),
                    GoogleFacebookLogIn(
                      label: 'Facebook',
                      onPresssed: () {},
                      child: const Image(
                          image: AssetImage('images/inapp/facebook.jpg')),
                    ), */
                    _isLoading
                        ? const CircularProgressIndicator()
                        : GoogleFacebookLogIn(
                            label: appLocale.guest,
                            onPresssed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              //await FirebaseAuth.instance.signInAnonymously();
                              //check network availability
                              var connectivityResult =
                                  await Connectivity().checkConnectivity();
                              // check if the user is not connected to mobile network and wifi.
                              if (connectivityResult !=
                                      ConnectivityResult.mobile &&
                                  connectivityResult !=
                                      ConnectivityResult.wifi) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: appLocale.noInternet,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                return;
                              }
                              // if there is internet then login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const CustomerBottomBar(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
