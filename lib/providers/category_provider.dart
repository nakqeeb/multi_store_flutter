import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/utilities/global_variables.dart';

import '../models/http_exception.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Future<void> fetchCategories() async {
    final url = Uri.https(API_URL, '/categories');
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
      final List<Category> loadedCategories = [];
      responseData['categories'].forEach((catData) {
        //print(catData);
        loadedCategories.add(Category.fromJson(catData));
      });
      // print(loadedCategories[0].productName);
      _categories = loadedCategories;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
