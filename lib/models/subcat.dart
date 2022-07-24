class Subcategory {
  String? enSubName;
  String? arSubName;
  String? imageUrl;
  String? id;
  String? createdAt;
  String? updatedAt;

  Subcategory({
    this.enSubName,
    this.arSubName,
    this.imageUrl,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  Subcategory.fromJson(Map<String, dynamic> json) {
    enSubName = json['enSubName'];
    arSubName = json['arSubName'];
    imageUrl = json['imageUrl'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enSubName'] = this.enSubName;
    data['arSubName'] = this.arSubName;
    data['imageUrl'] = this.imageUrl;
    data['_id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
