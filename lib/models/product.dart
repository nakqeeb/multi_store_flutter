class Product {
  String? id;
  String? productName;
  String? productDescription;
  //double? price;
  num? price;
  int? inStock;
  List<String>? productImages;
  int? discount;
  String? mainCategory;
  String? subCategory;
  String? supplier;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.productName,
    this.productDescription,
    this.price,
    this.inStock,
    this.productImages,
    this.discount,
    this.mainCategory,
    this.subCategory,
    this.supplier,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    price = json['price'];
    inStock = json['inStock'];
    productImages = json['productImages'].cast<String>();
    discount = json['discount'];
    mainCategory = json['mainCategory'];
    subCategory = json['subCategory'];
    supplier = json['supplier'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['price'] = this.price;
    data['inStock'] = this.inStock;
    data['productImages'] = this.productImages;
    data['discount'] = this.discount;
    data['mainCategory'] = this.mainCategory;
    data['subCategory'] = this.subCategory;
    data['supplier'] = this.supplier;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
