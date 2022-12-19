import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/utilities/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthCustomerProvider with ChangeNotifier {
  String? _token;
  Customer? _customer;
  bool _passwordsDoesNotMatched = false;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool get isAuth {
    return _token != null;
  }

  bool get passwordsDoesNotMatched {
    return _passwordsDoesNotMatched;
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
    };
    // print(customerData);
    final url = Uri.https(API_URL, '/customers/signup');
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
    final url = Uri.https(API_URL, '/customers/login');
    try {
      String? registrationToken = await messaging.getToken();
      print("FCM Registration Token: ");
      print(registrationToken);

      messaging.subscribeToTopic("orderCustomer");

      Map<String, String> data = {
        'email': email,
        'password': password,
        'fcmToken': registrationToken!,
      };
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

  // fetch single customer by id
  Future<Customer> fetchCustomerById(String customerId) async {
    final url = Uri.https(API_URL, '/customers/$customerId');
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
      Customer loadedCustomer = Customer.fromJson(responseData['customer']);
      _customer = loadedCustomer;
      notifyListeners();
      return loadedCustomer;
    } catch (err) {
      throw err;
    }
  }

  Future<void> resetPassword(String oldPassword, String newPassword) async {
    Map passwordData = {'oldPassword': oldPassword, 'newPassword': newPassword};
    final url = Uri.https(API_URL, '/customers/resetpassword');
    try {
      _passwordsDoesNotMatched = false;
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${token!}',
        },
        body: json.encode(passwordData),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        if (responseData['message'] == 'passwords_are_not_matched') {
          _passwordsDoesNotMatched = true;
          notifyListeners();
          return;
        }
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // update phone number
  Future<void> updatePhone(String phone) async {
    Map phoneNo = {'phone': phone};
    final url = Uri.https(API_URL, '/customers/phone');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${token!}',
        },
        body: json.encode(phoneNo),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      _customer?.phone = phone;
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
}
