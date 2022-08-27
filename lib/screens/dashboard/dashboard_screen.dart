import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/components/app_bar_title.dart';
import 'package:multi_store_app/screens/change_language/change_language_screen.dart';
import 'package:multi_store_app/screens/stores/visit_store_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_supplier_provider.dart';
import '../../providers/dark_theme_provider.dart';
import '../../services/global_methods.dart';
import '../welcome/welcome_screen.dart';
import 'sub_screens/supplier_balance/supplier_balance_screen.dart';
import 'sub_screens/supplier_orders/supplier_orders_screen.dart';
import 'sub_screens/supplier_statics/supplier_statics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> labels = [];

  List<IconData> icons = [
    Icons.store,
    Icons.shop_2_outlined,
    // Icons.edit,
    // Icons.settings,
    Icons.attach_money,
    Icons.show_chart,
  ];

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      VisitStoreScreen(
        supplier:
            Provider.of<AuthSupplierProvider>(context, listen: false).supplier!,
      ),
      const SupplierOrdersScreen(),
      // const EditBusinessScreen(),
      // const ManageProductsScreen(),
      const SupplierBalanceScreen(),
      const SupplierStaticsScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final authSupplierProvider = Provider.of<AuthSupplierProvider>(context);
    var themeState = Provider.of<DarkThemeProvider>(context);
    var isDarkTheme = themeState.isDarkTheme;
    labels = [
      appLocale!.my_store,
      appLocale.orders,
      // 'edit profile',
      // 'manage products',
      appLocale.balance,
      appLocale.statics
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          tooltip: appLocale.lang,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const ChangeLanguageScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.translate,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        title: AppBarTitle(
          title: appLocale.dashboard,
        ),
        actions: [
          IconButton(
            tooltip: isDarkTheme ? appLocale.dark_mode : appLocale.light_mode,
            onPressed: () {
              setState(() {
                themeState.setDarkTheme = !themeState.isDarkTheme;
              });
            },
            icon: Icon(
              isDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          IconButton(
            tooltip: appLocale.logout,
            onPressed: () {
              GlobalMethods.warningDialog(
                context: context,
                title: appLocale.logout,
                subtitle: appLocale.are_you_sure_logout,
                btnTitle: appLocale.yes,
                cancelBtn: appLocale.cancel,
                fct: () async {
                  await authSupplierProvider.logout();
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
              );
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          children: List.generate(
              4,
              (index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pages[index],
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            icons[index],
                            size: 50,
                          ),
                          Text(
                            labels[index].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              fontFamily: 'Acme',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
