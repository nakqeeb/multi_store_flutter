import 'package:multi_store_app/models/address.dart';

import 'customer.dart';
import 'product.dart';
import 'supplier.dart';

class Order {
  String? id;
  Customer? customer;
  Product? product;
  Supplier? supplier;
  String? addressId;
  String? name;
  String? phone;
  String? pincode;
  String? address;
  String? landmark;
  String? city;
  String? state;
  String? productName;
  String? productImage;
  num? productPrice;
  int? orderQuantity;
  num? orderPrice;
  String? deliveryStatus;
  String? deliveryDate;
  String? orderDate;
  String? paymentStatus;
  bool? orderReview;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
      this.customer,
      this.product,
      this.supplier,
      this.addressId,
      this.name,
      this.phone,
      this.pincode,
      this.address,
      this.landmark,
      this.city,
      this.state,
      this.productName,
      this.productImage,
      this.productPrice,
      this.orderQuantity,
      this.orderPrice,
      this.deliveryStatus,
      this.deliveryDate,
      this.orderDate,
      this.paymentStatus,
      this.orderReview,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    customer = json['customerId'] != null
        ? Customer.fromJson(json['customerId'])
        : null;
    product =
        json['productId'] != null ? Product.fromJson(json['productId']) : null;
    supplier = json['supplierId'] != null
        ? Supplier.fromJson(json['supplierId'])
        : null;
    addressId = json['addressId'];
    name = json['name'];
    phone = json['phone'];
    pincode = json['pincode'];
    address = json['address'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    productName = json['productName'];
    productImage = json['productImage'];
    productPrice = json['productPrice'];
    orderQuantity = json['orderQuantity'];
    orderPrice = json['orderPrice'];
    deliveryStatus = json['deliveryStatus'];
    deliveryDate = json['deliveryDate'];
    orderDate = json['orderDate'];
    paymentStatus = json['paymentStatus'];
    orderReview = json['orderReview'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    if (customer != null) {
      data['customerId'] = customer!.toJson();
    }
    if (product != null) {
      data['productId'] = product!.toJson();
    }
    if (supplier != null) {
      data['supplierId'] = supplier!.toJson();
    }
    data['addressId'] = addressId;
    data['name'] = name;
    data['phone'] = phone;
    data['pincode'] = pincode;
    data['address'] = address;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['productName'] = productName;
    data['productImage'] = productImage;
    data['productPrice'] = productPrice;
    data['orderQuantity'] = orderQuantity;
    data['orderPrice'] = orderPrice;
    data['deliveryStatus'] = deliveryStatus;
    data['deliveryDate'] = deliveryDate;
    data['orderDate'] = orderDate;
    data['paymentStatus'] = paymentStatus;
    data['orderReview'] = orderReview;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
