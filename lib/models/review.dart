import 'package:multi_store_app/models/customer.dart';

class Review {
  String? id;
  Customer? customer;
  String? productId;
  double? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;

  Review(
      {this.id,
      this.customer,
      this.productId,
      this.rating,
      this.comment,
      this.createdAt,
      this.updatedAt});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    customer = json['customerId'] != null
        ? Customer.fromJson(json['customerId'])
        : null;
    productId = json['productId'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    if (customer != null) {
      data['customerId'] = customer!.toJson();
    }
    data['productId'] = productId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
