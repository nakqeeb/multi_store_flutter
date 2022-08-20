import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  final String? authToken;

  AddressProvider(this.authToken, this._addresses);

  List<Address> get addresses {
    return [..._addresses];
  }

  Future<void> addAddress(Address newAddress) async {
    final url = Uri.http(API_URL, '/addresses');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(newAddress),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not Add address.');
      }
      _addresses.add(newAddress);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Address>> fetchAddresses() async {
    final url = Uri.http(API_URL, '/addresses');
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
      final List<Address> loadedAddresses = [];
      responseData['addresses'].forEach((addressData) {
        loadedAddresses.add(Address.fromJson(addressData));
      });
      _addresses = loadedAddresses;
      notifyListeners();
      return loadedAddresses; // return it to use this method in Future.builder()
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateAddress(String addressId, Map updatedAddress) async {
    final url = Uri.http(API_URL, '/addresses/$addressId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(updatedAddress),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update this address.');
      }
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final url = Uri.http(API_URL, '/addresses');
    try {
      final existingAddressIndex =
          _addresses.indexWhere((ad) => ad.id == addressId);
      Address? existingAddress = _addresses[
          existingAddressIndex]; // this is to avoid error (A value of type 'Null' can't be assigned to a variable of type 'Address'.) in this line >> existingAddress = null;
      _addresses.removeAt(existingAddressIndex);
      notifyListeners();
      final response = await http.delete(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode >= 400) {
        _addresses.insert(existingAddressIndex, existingAddress);
        notifyListeners();
        throw HttpException('Could not delete this Address.');
      }
      existingAddress = null;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
