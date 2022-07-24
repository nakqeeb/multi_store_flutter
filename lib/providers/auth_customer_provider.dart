import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_store_app/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/utilities/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthCustomerProvider with ChangeNotifier {
  String? _token;
  Customer? _customer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Customer? get customer {
    return _customer;
  }

  Future<void> signup(Customer newCustomer, String password) async {
    Map<String, String?> customerData = {
      "name": newCustomer.name,
      "email": newCustomer.email,
      "password": password,
      "profileImageUrl": newCustomer.profileImageUrl,
      "phone": newCustomer.phone,
      "address": newCustomer.address
    };
    // print(customerData);
    final url = Uri.http(API_URL, '/customers/signup');
    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(customerData),
      );
      // print(json.decode(response.body));
      final responseData = json.decode(response.body);

      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> login(String email, String password) async {
    Map<String, String> data = {
      'email': email,
      'password': password,
    };
    final url = Uri.http(API_URL, '/customers/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(data),
      );
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      _token = responseData['token'];
      _customer = Customer.fromJson(responseData['customer']);
      // print(_customer!.name);
      // print(_customer!.email);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final customerData = json.encode({
        'token': _token,
        'customer': _customer,
      });
      prefs.setString('customerData', customerData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('customerData')) {
      return false;
    }
    final extractedCustomerData =
        json.decode(prefs.getString('customerData')!) as Map<String, dynamic>;

    // print(extractedCustomerData);
    _token = extractedCustomerData['token'];
    _customer = Customer.fromJson(extractedCustomerData['customer']);
    print(_customer!.email);
    //print(_customer!.profileImageUrl);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _customer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('customerData'); // this will clear 'customerData' key only
    // prefs.clear(); // this will clear all SharedPreferences keys including the theme key
  }
}
