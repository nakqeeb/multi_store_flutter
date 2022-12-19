import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/product.dart';
import '../utilities/global_variables.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _wishlistProducts = [];
  final String? authToken;
  bool _isRemoved = false;
  WishlistProvider(this.authToken, this._wishlistProducts);

  List<Product> get wishlistProducts {
    return [..._wishlistProducts];
  }

  set wishlistProducts(List<Product> wishlistProducts) {
    _wishlistProducts = wishlistProducts;
    notifyListeners();
  }

  bool get isRemoved {
    return _isRemoved;
  }

  set isRemoved(bool value) {
    _isRemoved = value;
  }

  Future<void> addToWishlist(String productId) async {
    Map prodId = {'productId': productId};
    final url = Uri.https(API_URL, '/customers/specific/wishlist');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(prodId),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      await fetchWishlist();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Product>> fetchWishlist() async {
    final url = Uri.https(API_URL, '/customers/specific/wishlist');
    try {
      final response = await http.get(
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
      final List<Product> loadedProducts = [];
      responseData['customer']['wishlist'].forEach((productData) {
        //print(orderData);
        loadedProducts.add(Product.fromJson(productData));
      });
      /* loadedProducts.sort((a, b) {
        return a.orderDate!.compareTo(b.orderDate!);
      }); */
      _wishlistProducts = loadedProducts;
      notifyListeners();
      return loadedProducts; // return it to use this method in Future.builder()
    } catch (err) {
      throw err;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final url = Uri.https(API_URL, '/customers/specific/wishlist/$productId');
    try {
      final existingProductIndex =
          _wishlistProducts.indexWhere((p) => p.id == productId);
      Product? existingProduct = _wishlistProducts[
          existingProductIndex]; // this is to avoid error (A value of type 'Null' can't be assigned to a variable of type 'Address'.) in this line >> existingProduct = null;
      _wishlistProducts.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        _wishlistProducts.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      _isRemoved = true;
      existingProduct = null;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
