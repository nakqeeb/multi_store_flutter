class Supplier {
  String? id;
  String? storeName;
  String? email;
  String? storeLogoUrl;
  String? coverImageUrl;
  String? phone;
  bool? isActivated;
  String? createdAt;
  String? updatedAt;

  Supplier(
      {this.id,
      this.storeName,
      this.email,
      this.storeLogoUrl,
      this.coverImageUrl,
      this.phone,
      this.isActivated,
      this.createdAt,
      this.updatedAt});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    storeName = json['storeName'];
    email = json['email'];
    storeLogoUrl = json['storeLogoUrl'];
    coverImageUrl = json['coverImageUrl'];
    phone = json['phone'];
    isActivated = json['isActivated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    data['storeName'] = storeName;
    data['email'] = email;
    data['storeLogoUrl'] = storeLogoUrl;
    data['coverImageUrl'] = coverImageUrl;
    data['phone'] = phone;
    data['isActivated'] = isActivated;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
