import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/cart_item.dart';

import '../models/cart.dart';
import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class CartProvider with ChangeNotifier {
  Cart? _cart;
  final String? authToken;

  CartProvider(
    this.authToken,
    this._cart,
  );

  Cart? get cart {
    return _cart;
  }

  double get totalPrice {
    var total = 0.0;
    if (_cart?.items != null) {
      for (var item in _cart!.items!.toList()) {
        if (item.cartProduct!.discount! > 0) {
          total += item.quantity! *
              ((1 - (item.cartProduct!.discount! / 100)) *
                  item.cartProduct!.price!);
        } else {
          total += item.quantity! * item.cartProduct!.price!;
        }
      }
    }
    return total;
  }

  Future<void> fetchCart() async {
    final url = Uri.https(API_URL, '/carts');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      Cart loadedCart;
      loadedCart = Cart.fromJson(responseData['customer']['cart']);
      _cart = loadedCart;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  // add to cart or increase quantity by one
  // I will use {isCartPage} is used to avoid the error (RangeError (RangeError (index): Invalid value: Only valid value is 0: -1)) when add the product to cart first time
  Future<void> addToCart(String productId, {isCartPage = false}) async {
    final prodId = {"productId": productId};
    final url = Uri.https(API_URL, '/carts/increase-quantity-by-one');
    try {
      int? currentQtyIndex, existingQty;
      if (isCartPage) {
        currentQtyIndex =
            _cart?.items?.indexWhere((e) => e.cartProduct?.id == productId);
        existingQty = _cart?.items![currentQtyIndex!].quantity;
        _cart?.items![currentQtyIndex!].quantity =
            _cart!.items![currentQtyIndex].quantity! >
                    _cart!.items![currentQtyIndex].cartProduct!.inStock!
                ? _cart!.items![currentQtyIndex].cartProduct!.inStock!
                : existingQty! + 1;
      }
      notifyListeners();
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(prodId),
      );
      if (response.statusCode >= 400) {
        if (isCartPage) {
          _cart?.items![currentQtyIndex!].quantity = existingQty! - 1;
        }
        notifyListeners();
        throw HttpException('Could not Add to Cart.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);
      if (isCartPage) {
        fetchCart();
        notifyListeners();
      } else {
        await fetchCart();
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  // reduce quantity by one
  Future<void> reduceByOne(String productId) async {
    final prodId = {"productId": productId};
    final url = Uri.https(API_URL, '/carts/reduce-quantity-by-one');
    try {
      final currentQtyIndex =
          _cart?.items?.indexWhere((e) => e.cartProduct?.id == productId);
      int? existingQty = _cart?.items![currentQtyIndex!].quantity;
      _cart?.items![currentQtyIndex!].quantity = existingQty! - 1;
      notifyListeners();
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(prodId),
      );
      if (response.statusCode >= 400) {
        _cart?.items![currentQtyIndex!].quantity = existingQty! + 1;
        notifyListeners();
        throw HttpException('Could not delete item.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);
      fetchCart();
      // notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // delete one item
  Future<void> removeItem(String productId) async {
    final url = Uri.https(API_URL, '/carts/$productId');
    try {
      final existingQtyIndex =
          _cart?.items?.indexWhere((e) => e.cartProduct?.id == productId);
      CartItem? existingQty = _cart?.items![existingQtyIndex!];
      _cart?.items!.removeAt(existingQtyIndex!);
      notifyListeners();
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
      );
      if (response.statusCode >= 400) {
        _cart?.items?.insert(existingQtyIndex!, existingQty!);
        notifyListeners();
        throw HttpException('Could not delete item.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);
      fetchCart();
      //notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // clear cart
  Future<void> clearCart() async {
    final url = Uri.https(API_URL, '/carts/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not clear cart.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);
      _cart!.items!.clear();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  /*  Future<void> addToCart(Cart newProduct) async {
    final url = Uri.https(API_URL, '/products');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(newProduct),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not Add product.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);

      fetchProducts();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  } */
}
