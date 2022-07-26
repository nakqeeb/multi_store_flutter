import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/supplier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class AuthSupplierProvider with ChangeNotifier {
  String? _token;
  Supplier? _supplier;
  Supplier? _productSupplier;
  List<Supplier> _suppliers = []; // to fetch stores and other supliers info
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Supplier? get supplier {
    return _supplier;
  }

  Supplier? get productSupplier {
    return _productSupplier;
  }

  List<Supplier> get suppliers {
    return [..._suppliers];
  }

  /* Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  } */

  Future<void> signup(Supplier newSupplier, String password) async {
    Map<String, dynamic> supplierData = {
      "storeName": newSupplier.storeName,
      "email": newSupplier.email,
      "password": password,
      "storeLogoUrl": newSupplier.storeLogoUrl,
      "phone": newSupplier.phone,
      "coverImageUrl": newSupplier.coverImageUrl,
      "isActivated": newSupplier.isActivated
    };
    // print(supplierData);
    final url = Uri.https(API_URL, '/suppliers/signup');
    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(supplierData),
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
    final url = Uri.https(API_URL, '/suppliers/login');
    try {
      String? registrationToken = await messaging.getToken();
      print("FCM Registration Token: ");
      print(registrationToken);

      messaging.subscribeToTopic("orderSupplier");
      /* messaging.unsubscribeFromTopic("allDrivers");
      messaging.unsubscribeFromTopic("allUsers"); */
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
      _supplier = Supplier.fromJson(responseData['supplier']);
      // print(_supplier!.name);
      // print(_supplier!.email);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final supplierData = json.encode({
        'token': _token,
        'supplier': _supplier,
      });
      prefs.setString('supplierData', supplierData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('supplierData')) {
      return false;
    }
    final extractedsupplierData =
        json.decode(prefs.getString('supplierData')!) as Map<String, dynamic>;

    // print(extractedsupplierData);
    _token = extractedsupplierData['token'];
    _supplier = Supplier.fromJson(extractedsupplierData['supplier']);
    await fetchSupplierById(_supplier!.id
        .toString()); // the supplier data in SharedPreferences might be old (the info might be old) so I have to fetch it again from the database once we call autologin

    //print(_supplier!.email);
    //print(_supplier!.profileImageUrl);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _supplier = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('supplierData'); // this will clear 'supplierData' key only
    // prefs.clear(); // this will clear all SharedPreferences keys including the theme key
  }

  // fetch all suppliers
  Future<List<Supplier>> fetchSuppliers() async {
    final url = Uri.https(API_URL, '/suppliers');
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
      final List<Supplier> loadedSuppliers = [];
      responseData['suppliers'].forEach((prodData) {
        //print(prodData);
        loadedSuppliers.add(Supplier.fromJson(prodData));
      });
      // print(loadedSuppliers[0].productName);
      _suppliers = loadedSuppliers;
      notifyListeners();
      return loadedSuppliers; // return it to use this method in FutureBuilder()
    } catch (err) {
      throw err;
    }
  }

  // fetch single supplier by id
  Future<Supplier> fetchSupplierById(String supplierId) async {
    final url = Uri.https(API_URL, '/suppliers/$supplierId');
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
      Supplier loadedSupplier = Supplier.fromJson(responseData['supplier']);
      _supplier = loadedSupplier;
      notifyListeners();
      return loadedSupplier; // return it to use this method in FutureBuilder()
    } catch (err) {
      throw err;
    }
  }

  // fetch product supplier by id
  Future<void> fetchProductSupplierById(String supplierId) async {
    final url = Uri.https(API_URL, '/suppliers/$supplierId');
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
      Supplier loadedSupplier = Supplier.fromJson(responseData['supplier']);
      _productSupplier = loadedSupplier;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // update supplier store info
  Future<void> updateStoreInfo(Supplier updatedSupplier) async {
    final url = Uri.https(API_URL, '/suppliers');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(updatedSupplier),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update store information.');
      }
      await fetchSupplierById(_supplier!.id.toString());
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
