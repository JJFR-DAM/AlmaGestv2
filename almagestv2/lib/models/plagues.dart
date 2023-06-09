class Plagues {
  bool? success;
  List<PlagueData>? data;
  String? message;

  Plagues({this.success, this.data, this.message});

  Plagues.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PlagueData>[];
      json['data'].forEach((v) {
        data!.add(PlagueData.fromJson(v));
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

class PlagueData {
  int? id;
  String? name;
  String? img;
  int? deleted;
  String? createdAt;
  String? updatedAt;

  PlagueData({
    this.id,
    this.name,
    this.img,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  PlagueData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
