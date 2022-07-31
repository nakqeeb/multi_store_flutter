import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:multi_store_app/models/order.dart';

import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  final String? authToken;

  OrderProvider(this.authToken, this._orders);
  List<Order> get orders {
    return [..._orders];
  }

  set setOrder(Order updatedOrder) {
    final updatedOrderIndex =
        _orders.indexWhere((element) => element.id == updatedOrder.id);
    _orders[updatedOrderIndex] = updatedOrder;
    notifyListeners();
  }

  Future<void> placeOrder(Map order) async {
    final url = Uri.http(API_URL, '/orders');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(order),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not place Order.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Order>> fetchOrders() async {
    final url = Uri.http(API_URL, '/orders');
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
      final List<Order> loadedOrders = [];
      responseData['orders'].forEach((orderData) {
        //print(prodData);
        loadedOrders.add(Order.fromJson(orderData));
      });
      /* loadedOrders.sort((a, b) {
        return a.orderDate!.compareTo(b.orderDate!);
      }); */
      _orders = loadedOrders;
      notifyListeners();
      return loadedOrders; // return it to use this method in Future.builder()
    } catch (err) {
      throw err;
    }
  }

  // update deliveryDate
  Future<void> updateOrder(
      String? orderId, String deliveryStatus, DateTime? deliveryDate) async {
    final data = {
      "deliveryDate": deliveryDate?.toIso8601String(),
      "deliveryStatus": deliveryStatus
    };
    final url = Uri.http(API_URL, '/orders/$orderId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(data),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update deliveryDate.');
      }
      //final extractedData = json.decode(response.body);
      //print(extractedData);

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  /* final _sockerURL = 'http://192.168.0.111:3000';
  IO.Socket? _socket;

  static const _socketEvent = 'event_1';

  void connect() {
    _socket = IO.io(_sockerURL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    _socket!.connect();
    _socket!.onConnect((data) => print('Connected'));
    print(_socket!.connected);
    _socket!.on('products', (data) {
      // print(data);
      // print(data['action']);
      if (data['action'] == 'updateOrder') {
        Order updatedOrder = data['order'];
        /* final updatedOrders = [..._orders];
        final updatedOrderIndex = updatedOrders
            .indexWhere((element) => element.id == updatedOrder.id);
        if (updatedOrderIndex > -1) {
          updatedOrders[updatedOrderIndex] = updatedOrder;
        }
        _orders = updatedOrders; */
        fetchOrders();
        notifyListeners();
        print(updatedOrder.deliveryDate);
      }
    }); // 'products' in .on() is the event name that I use in the backend
  } */
}
