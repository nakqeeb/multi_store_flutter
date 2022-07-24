import 'subcat.dart';

class Category {
  String? enName;
  String? arName;
  List<Subcategory>? subcategories;
  String? id;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  Category(
      {this.enName,
      this.arName,
      this.subcategories,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  Category.fromJson(Map<String, dynamic> json) {
    enName = json['enName'];
    arName = json['arName'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategory>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(new Subcategory.fromJson(v));
      });
    }
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enName'] = this.enName;
    data['arName'] = this.arName;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
