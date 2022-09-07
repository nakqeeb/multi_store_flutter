/* class Customer {
  String? id;
  String? name;
  String? email;
  String? profileImageUrl;
  String? phone;
  String? address;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.profileImageUrl,
      this.phone,
      this.address,
      this.createdAt,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    profileImageUrl = json['profileImageUrl'];
    phone = json['phone'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profileImageUrl'] = this.profileImageUrl;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
 */

import 'package:multi_store_app/models/product.dart';

import 'cart.dart';

class Customer {
  String? id;
  String? name;
  String? email;
  String? profileImageUrl;
  String? phone;
  String? fcmToken;
  Cart? cart;
  List<dynamic>? wishlist;
  List<String>? followingStores;
  String? createdAt;
  String? updatedAt;

  Customer({
    this.id,
    this.name,
    this.email,
    this.profileImageUrl,
    this.phone,
    this.fcmToken,
    this.cart,
    this.wishlist,
    this.followingStores,
    this.createdAt,
    this.updatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    profileImageUrl = json['profileImageUrl'];
    phone = json['phone'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (wishlist is Product) {
      if (json['wishlist'] != null) {
        wishlist = <Product>[];
        json['wishlist'].forEach((v) {
          wishlist!.add(Product.fromJson(v));
        });
      }
    } else if (wishlist is String) {
      if (json['wishlist'] != null) {
        wishlist = <String>[];
        json['wishlist'].forEach((v) {
          wishlist!.add(v);
        });
      }
    }
    if (json['followingStores'] != null) {
      followingStores = <String>[];
      json['followingStores'].forEach((v) {
        followingStores!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (cart != null) {
      data['cart'] = cart!.toJson();
    }
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profileImageUrl'] = profileImageUrl;
    data['phone'] = phone;
    data['fcmToken'] = fcmToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (wishlist != null) {
      data['wishlist'] = wishlist!.map((v) => v.toJson()).toList();
    }
    data['followingStores'] = followingStores;
    return data;
  }
}
