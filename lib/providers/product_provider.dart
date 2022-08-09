import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/utilities/global_variables.dart';

import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  late Product _product;
  final String? authToken;

  ProductProvider(this.authToken, this._products);

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

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.http(API_URL, '/products');
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
    final url = Uri.http(API_URL, '/products');
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

  Future<void> fetchProductsById(String prodId) async {
    final url = Uri.http(API_URL, '/products/$prodId');
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
      _product = Product.fromJson(responseData['product']);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> fetchProductsByCategoryId(String catId) async {
    final url = Uri.http(API_URL, '/products/category/$catId');
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
    } catch (err) {
      throw err;
    }
  }

  Future<List<Product>> productsBySupplierId(String id) async {
    final url = Uri.http(API_URL, '/products/supplierproducts/$id');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      /* if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      } */
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

  Future<void> updateProduct(String prodId, Map updatedProduct) async {
    final url = Uri.http(API_URL, '/products/$prodId');
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
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
