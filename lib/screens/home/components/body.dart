/* import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:multi_store_app/screens/home/components/gallery_tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _sockerURL = 'http://192.168.0.110:3000';
  IO.Socket? _socket;

  static const _socketEvent = 'event_1';

  void connect() {
    _socket = IO.io(_sockerURL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    _socket!.connect();
    _socket!.onConnect((data) => print('Connected'));
    print(_socket!.connected);
    _socket!.on('products', (data) {
      // print(data);
      // print(data['action']);
      if (data['action'] == 'create') {
        Product newProduct = Product.fromJson(data['product']);
        Provider.of<ProductProvider>(context, listen: false).setProduct =
            newProduct;
        print(Provider.of<ProductProvider>(context, listen: false)
            .products
            .last
            .productName);
      }
    }); // 'products' in .on() is the event name that I use in the backend
  }

  @override
  void initState() {
    super.initState();
    connect();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return TabBarView(children: [
      Center(
        child: TextButton(
            onPressed: () async {
              await productProvider.fetchProducts();
              print(productProvider.products[0].productName);
            },
            child: const Text('Fetch data')),
      ),
      /* const GalleryTabScreen(
        index: 1,
      ), */
      const Center(
        child: Text('Shoes'),
      ),
      const Center(
        child: Text('Bags'),
      ),
      const Center(
        child: Text('Electronics'),
      ),
      const Center(
        child: Text('Accessories'),
      ),
      const Center(
        child: Text('Home & Garden'),
      ),
      const Center(
        child: Text('Kids'),
      ),
      const Center(
        child: Text('Beauty'),
      ),
    ]);
  }
}
 */