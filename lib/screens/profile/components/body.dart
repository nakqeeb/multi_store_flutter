import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/screens/address/address_screen.dart';
import 'package:multi_store_app/screens/change_language/change_language_screen.dart';
import 'package:multi_store_app/screens/change_password/change_password_screen.dart';
import 'package:multi_store_app/screens/wishlist/wishlist_screen.dart';
import 'package:multi_store_app/models/customer.dart';
import 'package:multi_store_app/providers/auth_customer_provider.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/screens/cart/cart_screen.dart';
import 'package:multi_store_app/screens/profile/components/toggle_theme.dart';
import 'package:multi_store_app/screens/welcome/welcome_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../../providers/dark_theme_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../services/utils.dart';
import '../../order/orders_screen.dart';
import 'profile_header_label.dart';
import 'repeated_list_tile.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final size = Utils(context).getScreenSize;
    final authCustomerProvider = Provider.of<AuthCustomerProvider>(context);
    final isAuth = authCustomerProvider.isAuth;
    final customer = authCustomerProvider.customer ??
        Customer(
          name: appLocale!.guest,
          email: null,
          phone: null,
        );

    Future.delayed(Duration.zero, () async {
      _phoneTextController.text = customer.phone ?? '';
    });
    // to clear _cart when logout
    final cartProvider = Provider.of<CartProvider>(context);
    // to clear _wishlistProducts when logout
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Stack(
      children: [
        Container(
          height: 230,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDarkTheme ? const Color(0xFF475461) : const Color(0xFFaad4f1),
                isDarkTheme ? const Color(0xFF758699) : const Color(0xFFdae3e3)
              ],
            ),
          ),
        ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              //centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              pinned: true,
              expandedHeight: 140,
              backgroundColor: isDarkTheme
                  ? const Color(0xFF475461)
                  : const Color(0xFFD6EAF8),
              flexibleSpace: LayoutBuilder(
                builder: (ctx, constraints) {
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: constraints.biggest.height <= 120 ? 1 : 0,
                      child: Text(
                        appLocale!.profile,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isDarkTheme
                                ? const Color(0xFF475461)
                                : const Color(0xFFaad4f1),
                            isDarkTheme
                                ? const Color(0xFF758699)
                                : const Color(0xFFdae3e3)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 25, left: 30, right: 30),
                        child: Row(children: [
                          /* CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                const AssetImage('images/inapp/guest.jpg'),
                            child: customer.profileImageUrl == null
                                ? null
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(customer.profileImageUrl!),
                                  ),
                          ), */
                          CircleAvatar(
                            radius: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: customer.profileImageUrl == null
                                  ? Image.asset(
                                      'images/inapp/guest.gif',
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    )
                                  : FadeInImage.assetNetwork(
                                      placeholder: 'images/inapp/guest.gif',
                                      placeholderFit: BoxFit.cover,
                                      image: customer.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Text(
                              customer.name!.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          )
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? const Color(0xFFdae3e3).withOpacity(0.4)
                          : const Color(0xFFdae3e3).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF475461)
                                : const Color(0xFFaad4f1),
                            borderRadius: isArabic
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(
                                    back: AppBarBackButton(),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: isArabic
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              height: 40,
                              width: size.width * 0.2,
                              child: Center(
                                  child: Text(
                                appLocale!.cart,
                                // style: Theme.of(context).textTheme.headline6,
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF1c2732)
                                : const Color(0xFFf9f7f7),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (isAuth) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(),
                                  ),
                                );
                              } else {
                                GlobalMethods.warningDialog(
                                  title: appLocale.login,
                                  subtitle: appLocale.login_first,
                                  btnTitle: appLocale.login,
                                  cancelBtn: appLocale.cancel,
                                  fct: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const WelcomeScreen(),
                                      ),
                                    );
                                  },
                                  context: context,
                                );
                              }
                            },
                            child: SizedBox(
                              height: 40,
                              width: size.width * 0.2,
                              child: Center(
                                  child: Text(
                                appLocale.orders,
                                // style: Theme.of(context).textTheme.headline6,
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF475461)
                                : const Color(0xFFaad4f1),
                            borderRadius: isArabic
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (isAuth) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WishlistScreen(),
                                  ),
                                );
                              } else {
                                GlobalMethods.warningDialog(
                                  title: appLocale.login,
                                  subtitle: appLocale.login_first,
                                  btnTitle: appLocale.login,
                                  cancelBtn: appLocale.cancel,
                                  fct: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const WelcomeScreen(),
                                      ),
                                    );
                                  },
                                  context: context,
                                );
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: isArabic
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              height: 40,
                              width: size.width * 0.2,
                              child: Center(
                                child: Text(
                                  appLocale.wishlist,
                                  // style: Theme.of(context).textTheme.headline6,
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: isDarkTheme
                        ? const Color(0xFF1c2732)
                        : const Color(0xFFf9f7f7),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Image(
                            image: isDarkTheme
                                ? const AssetImage('images/inapp/logo_dark.png')
                                : const AssetImage(
                                    'images/inapp/logo_light.png'),
                          ),
                        ),
                        ProfileHeaderLabel(
                          headerLabel: '  ${appLocale.account_info}  ',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? const Color(0xFF758699)
                                  : const Color(0xFFdae3e3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                RepeatedListTile(
                                  icon: Icons.email,
                                  title: appLocale.email_address,
                                  subtitle: customer.email,
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  icon: Icons.phone,
                                  title: appLocale.phone,
                                  subtitle: customer.phone,
                                  isClickable: true,
                                  onPressed: () async {
                                    if (isAuth) {
                                      await _showPhoneDialog();
                                    } else {
                                      GlobalMethods.warningDialog(
                                        title: appLocale.login,
                                        subtitle: appLocale.login_first,
                                        btnTitle: appLocale.login,
                                        cancelBtn: appLocale.cancel,
                                        fct: () {
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const WelcomeScreen(),
                                            ),
                                          );
                                        },
                                        context: context,
                                      );
                                    }
                                  },
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  onPressed: () {
                                    if (isAuth) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const AddressScreen()));
                                    } else {
                                      GlobalMethods.warningDialog(
                                        title: appLocale.login,
                                        subtitle: appLocale.login_first,
                                        btnTitle: appLocale.login,
                                        cancelBtn: appLocale.cancel,
                                        fct: () {
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const WelcomeScreen(),
                                            ),
                                          );
                                        },
                                        context: context,
                                      );
                                    }
                                  },
                                  icon: Icons.location_pin,
                                  title: appLocale.address_book,
                                  // subtitle: customer.address,
                                  isClickable: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                        ProfileHeaderLabel(
                            headerLabel: '  ${appLocale.account_settings}  '),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? const Color(0xFF758699)
                                  : const Color(0xFFdae3e3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                /* RepeatedListTile(
                                  title: appLocale.edit_profile,
                                  icon: Icons.edit,
                                  isClickable: true,
                                  onPressed: () {},
                                ),
                                listDivider(), */
                                RepeatedListTile(
                                  title: appLocale.change_password,
                                  icon: Icons.lock,
                                  isClickable: true,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen(),
                                    ));
                                  },
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  title: appLocale.change_language,
                                  icon: Icons.language,
                                  isClickable: true,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangeLanguageScreen(),
                                    ));
                                  },
                                ),
                                listDivider(),
                                const Center(
                                  child: ToggleTheme(),
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  title: isAuth
                                      ? appLocale.logout
                                      : appLocale.login,
                                  icon: Icons.logout,
                                  isClickable: true,
                                  onPressed: () {
                                    if (isAuth) {
                                      GlobalMethods.warningDialog(
                                        context: context,
                                        title: appLocale.logout,
                                        subtitle: appLocale.are_you_sure_logout,
                                        btnTitle: appLocale.yes,
                                        cancelBtn: appLocale.cancel,
                                        fct: () async {
                                          await authCustomerProvider.logout();
                                          cartProvider.cart?.items?.clear();
                                          wishlistProvider.wishlistProducts =
                                              [];

                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const WelcomeScreen(),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const WelcomeScreen(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Padding listDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        thickness: 1,
      ),
    );
  }

  Future<void> _showPhoneDialog() {
    final appLocale = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocale!.phone),
          content: TextField(
            controller: _phoneTextController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: appLocale.enter_phone),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                GlobalMethods.loadingDialog(
                    title: appLocale.please_wait, context: context);
                await Provider.of<AuthCustomerProvider>(context, listen: false)
                    .updatePhone(_phoneTextController.text);

                Navigator.pop(context);

                Navigator.pop(context);
              },
              child: Text(appLocale.change,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            )
          ],
        );
      },
    );
  }
}
