import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/cart.dart';
import 'cart_item_tile.dart';

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return ListView.builder(
              itemCount: cartProvider.cart!.items!.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cart!.items![index];
                return CartItemTile(
                  key: ValueKey(cartItem.id),
                  cartItem: cartItem,
                  // cart: context.read<Cart>(),
                );
              });
        },
      ),
    );
  }
}
