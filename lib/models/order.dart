import 'customer.dart';
import 'product.dart';
import 'supplier.dart';

class Order {
  String? id;
  Customer? customer;
  Product? product;
  Supplier? supplier;
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
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    supplier =
        json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null;
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
      data['customer'] = customer!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
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
