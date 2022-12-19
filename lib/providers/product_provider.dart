import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/utilities/global_variables.dart';

import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  Product _product;
  final String? authToken;

  bool _isUpdated = false;
  bool _isDeleted = false;

  ProductProvider(this.authToken, this._products, this._product);

  List<Product> get products {
    return [..._products];
  }

  Product get product {
    return _product;
  }

  set setProduct(Product newProduct) {
    _products.add(newProduct);
    notifyListeners();
  }

  bool get isUpdated {
    return _isUpdated;
  }

  set isUpdated(bool value) {
    _isUpdated = value;
  }

  bool get isDeleted {
    return _isDeleted;
  }

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  List<Product> searchQuery(String searchText) {
    List<Product> searchList = _products
        .where(
          (element) => element.productName!.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }

  Future<void> addProduct(Product newProduct) async {
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
  }

  Future<void> fetchProducts() async {
    final url = Uri.https(API_URL, '/products');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      final List<Product> loadedProducts = [];
      responseData['products'].forEach((prodData) {
        //print(prodData);
        loadedProducts.add(Product.fromJson(prodData));
      });
      // print(loadedProducts[0].productName);
      final List<Product> prods =
          loadedProducts.where((element) => element.inStock != 0).toList();
      _products = prods;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<Product> fetchProductsById(String prodId) async {
    final url = Uri.https(API_URL, '/products/$prodId');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      // print(loadedProducts[0].productName);
      Product loadedProduct = Product.fromJson(responseData['product']);
      _product = loadedProduct;
      /* comment notifyListeners() to avoid error FlutterError (A ProductProvider was used after being disposed.
        Once you have called dispose() on a ProductProvider, it can no longer be used.) */
      // notifyListeners();
      return loadedProduct;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Product>> fetchProductsByCategoryId(String catId) async {
    final url = Uri.https(API_URL, '/products/category/$catId');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      final List<Product> loadedProducts = [];
      responseData['products'].forEach((prodData) {
        //print(prodData);
        loadedProducts.add(Product.fromJson(prodData));
      });
      // print(loadedProducts[0].productName);
      _products = loadedProducts;
      notifyListeners();
      return loadedProducts;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Product>> fetchProductsBySupplierId(String id) async {
    final url = Uri.https(API_URL, '/products/supplierproducts/$id');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      final List<Product> loadedProducts = [];
      responseData['supplierProducts'].forEach((prodData) {
        loadedProducts.add(Product.fromJson(prodData));
      });
      notifyListeners();
      return loadedProducts;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String prodId, Map updatedProduct) async {
    final url = Uri.https(API_URL, '/products/$prodId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(updatedProduct),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update this product.');
      }
      await fetchProductsById(prodId);
      _isUpdated = true;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> deleteProduct(String prodId) async {
    final url = Uri.https(API_URL, '/products/$prodId');
    try {
      final existingProductIndex =
          _products.indexWhere((prod) => prod.id == prodId);
      // var existingProduct = _products[existingProductIndex]; // this is Max code
      Product? existingProduct = _products[
          existingProductIndex]; // this is to avoid error (A value of type 'Null' can't be assigned to a variable of type 'Product'.) in this line >> existingProduct = null;
      _products.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode >= 400) {
        _products.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete this product.');
      }
      existingProduct = null;
      _isDeleted = true;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
