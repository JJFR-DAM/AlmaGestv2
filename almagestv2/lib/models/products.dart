class Products {
  bool? success;
  List<ProductData>? data;
  String? message;

  Products({this.success, this.data, this.message});

  Products.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ProductData {
  int? id;
  String? name;
  String? img;
  String? howToUse;
  String? createdAt;
  String? updatedAt;

  ProductData({this.id, this.name, this.img, this.createdAt, this.updatedAt});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    howToUse = json['how_to_use'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['how_to_use'] = howToUse;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
