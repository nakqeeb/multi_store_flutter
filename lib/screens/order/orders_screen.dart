import 'package:flutter/material.dart';

import '../../components/app_bar_back_button.dart';
import '../../components/app_bar_title.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(
          title: 'Orders',
        ),
        centerTitle: true,
      ),
    );
  }
}
