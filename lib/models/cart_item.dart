import 'package:multi_store_app/models/product.dart';

class CartItem {
  Product? cartProduct;
  int? quantity;
  String? id;

  CartItem({this.cartProduct, this.quantity, this.id});

  CartItem.fromJson(Map<String, dynamic> json) {
    cartProduct =
        json['productId'] != null ? Product.fromJson(json['productId']) : null;

    quantity = json['quantity'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (cartProduct != null && cartProduct is Product) {
      data['productId'] = cartProduct!.toJson();
    } else {
      data['productId'] = cartProduct;
    }
    data['quantity'] = quantity;
    data['_id'] = id;
    return data;
  }
}

/* class CartProduct {
  String? id;
  String? productName;
  double? price;

  CartProduct({this.id, this.productName, this.price});

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['productName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    return data;
  }
} */
