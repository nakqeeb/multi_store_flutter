import 'package:multi_store_app/models/address.dart';

import 'customer.dart';
import 'product.dart';
import 'supplier.dart';

class Order {
  String? id;
  Customer? customer;
  Product? product;
  Supplier? supplier;
  Address? address;
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
    address =
        json['addressId'] != null ? Address.fromJson(json['addressId']) : null;
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
    if (address != null) {
      data['addressId'] = address!.toJson();
    }
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
