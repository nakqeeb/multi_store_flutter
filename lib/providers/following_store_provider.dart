import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/supplier.dart';

import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class FollowingStoreProvider with ChangeNotifier {
  List<Supplier> _followingStores = [];
  final String? authToken;
  bool _isFollow = false;
  FollowingStoreProvider(this.authToken, this._followingStores);

  List<Supplier> get followingStores {
    return [..._followingStores];
  }

  set followingStores(List<Supplier> followingStores) {
    _followingStores = followingStores;
    notifyListeners();
  }

  bool get isFollow {
    return _isFollow;
  }

  set isFollow(bool value) {
    _isFollow = value;
  }

  Future<void> followStore(String supplierId) async {
    Map supId = {'supplierId': supplierId};
    final url = Uri.https(API_URL, '/customers/specific/followingstores');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(supId),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      await fetchFollowingStores();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Supplier>> fetchFollowingStores() async {
    final url = Uri.https(API_URL, '/customers/specific/followingstores');
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
      final List<Supplier> loadedSuppliers = [];
      responseData['customer']['followingStores'].forEach((storeData) {
        loadedSuppliers.add(Supplier.fromJson(storeData));
      });
      _followingStores = loadedSuppliers;
      notifyListeners();
      return loadedSuppliers; // return it to use this method in Future.builder()
    } catch (err) {
      throw err;
    }
  }

  Future<void> unfollowStore(String supplierId) async {
    final url =
        Uri.https(API_URL, '/customers/specific/followingstores/$supplierId');
    try {
      final existingStoreIndex =
          _followingStores.indexWhere((p) => p.id == supplierId);
      Supplier? existingStore = _followingStores[
          existingStoreIndex]; // this is to avoid error (A value of type 'Null' can't be assigned to a variable of type 'Address'.) in this line >> existingStore = null;
      _followingStores.removeAt(existingStoreIndex);
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
        _followingStores.insert(existingStoreIndex, existingStore);
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      existingStore = null;
      await fetchFollowingStores();
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
