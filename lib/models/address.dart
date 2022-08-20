class Address {
  String? id;
  String? customerId;
  String? name;
  String? phone;
  String? pincode;
  String? address;
  String? landmark;
  String? city;
  String? state;
  bool? isDefault;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.customerId,
      this.name,
      this.phone,
      this.pincode,
      this.address,
      this.landmark,
      this.city,
      this.state,
      this.isDefault,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    customerId = json['customerId'];
    name = json['name'];
    phone = json['phone'];
    pincode = json['pincode'];
    address = json['address'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    isDefault = json['isDefault'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    data['customerId'] = customerId;
    data['name'] = name;
    data['phone'] = phone;
    data['pincode'] = pincode;
    data['address'] = address;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['isDefault'] = isDefault;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
