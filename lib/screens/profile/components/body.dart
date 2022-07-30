import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';
import 'package:multi_store_app/fetch_screen.dart';
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
import '../../../services/utils.dart';
import '../../order/orders_screen.dart';
import 'profile_header_label.dart';
import 'repeated_list_tile.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final size = Utils(context).getScreenSize;
    final authCustomerProvider = Provider.of<AuthCustomerProvider>(context);
    final isAuth = authCustomerProvider.isAuth;
    final customer = authCustomerProvider.customer ??
        Customer(
          name: 'Guest',
          email: '',
          address: '',
          phone: '',
        );
    // to clear _cart when logout
    final cartProvider = Provider.of<CartProvider>(context);
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
                        'Account',
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
                        padding: const EdgeInsets.only(top: 25, left: 30),
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
                            padding: const EdgeInsets.only(left: 25),
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
                            borderRadius: const BorderRadius.only(
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
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
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
                                'Cart',
                                style: Theme.of(context).textTheme.headline6,
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
                                  title: 'Login',
                                  subtitle: 'You need to login first',
                                  btnTitle: 'Login',
                                  fct: () {
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
                                'Orders',
                                style: Theme.of(context).textTheme.headline6,
                              )),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF475461)
                                : const Color(0xFFaad4f1),
                            borderRadius: const BorderRadius.only(
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
                                  title: 'Login',
                                  subtitle: 'You need to login first',
                                  btnTitle: 'Login',
                                  fct: () {
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
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
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
                                  'Wishlist',
                                  style: Theme.of(context).textTheme.headline6,
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
                        const ProfileHeaderLabel(
                          headerLabel: '  Account Info  ',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 260,
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
                                  title: 'Email Address',
                                  subtitle: customer.email,
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  icon: Icons.phone,
                                  title: 'Phone No',
                                  subtitle: customer.phone,
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  icon: Icons.location_pin,
                                  title: 'Address',
                                  subtitle: customer.address,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const ProfileHeaderLabel(
                            headerLabel: '  Account Settings  '),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 355,
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? const Color(0xFF758699)
                                  : const Color(0xFFdae3e3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                RepeatedListTile(
                                  title: 'Edit Profile',
                                  icon: Icons.edit,
                                  isSettings: false,
                                  onPressed: () {},
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  title: 'Change Password',
                                  icon: Icons.lock,
                                  isSettings: false,
                                  onPressed: () {},
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  title: 'Change Language',
                                  icon: Icons.language,
                                  isSettings: false,
                                  onPressed: () {
                                    //authCustomerProvider.tryAutoLogin();
                                  },
                                ),
                                listDivider(),
                                const Center(
                                  child: ToggleTheme(),
                                ),
                                listDivider(),
                                RepeatedListTile(
                                  title: isAuth ? 'Logout' : 'Login',
                                  icon: Icons.logout,
                                  isSettings: false,
                                  onPressed: () {
                                    if (isAuth) {
                                      GlobalMethods.warningDialog(
                                        context: context,
                                        title: 'Sign out',
                                        subtitle:
                                            'Do you really want to sign out?',
                                        fct: () async {
                                          await authCustomerProvider.logout();
                                          cartProvider.cart?.items?.clear();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => WelcomeScreen(),
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
}
