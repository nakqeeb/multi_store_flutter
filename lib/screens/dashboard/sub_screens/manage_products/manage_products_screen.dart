import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app/providers/auth_supplier_provider.dart';
import 'package:provider/provider.dart';
import '../../../../components/app_bar_back_button.dart';
import '../../../../components/app_bar_title.dart';
import '../../../../components/product_grid_component_widget.dart';
import '../../../../models/product.dart';
import '../../../../providers/product_provider.dart';
import '../../../error/error_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  Future<List<Product>>? _supplierProducts;
  @override
  void initState() {
    _supplierProducts = Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsBySupplierId(
            Provider.of<AuthSupplierProvider>(context, listen: false)
                .supplier!
                .id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(
          title: 'Manage Products',
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _supplierProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingFour(
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const ErrorScreen(
                  title: 'Opps! Something went wrong',
                  subTitle: 'Please try to reload the application!');
            } else if (snapshot.data!.isNotEmpty) {
              return SingleChildScrollView(
                child: MasonryGridView.count(
                  itemCount: snapshot.data!.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductGridComponentWidget(
                      product: snapshot.data![index],
                    );
                  },
                ),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'You have no products yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme',
                      letterSpacing: 1.5),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No products loaded!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme',
                      letterSpacing: 1.5),
                ),
              );
            }
          } else {
            return Center(child: Text('State: ${snapshot.connectionState}'));
          }
        },
      ),
    );
  }
}
