class Likes {
  bool? success;
  List<LikeData>? data;
  String? message;

  Likes({this.success, this.data, this.message});

  Likes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <LikeData>[];
      json['data'].forEach((v) {
        data!.add(LikeData.fromJson(v));
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

class LikeData {
  int? id;
  String? opinionId;
  String? userId;
  String? createdAt;
  String? updatedAt;

  LikeData({
    this.id,
    this.opinionId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  LikeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    opinionId = json['opinion_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['opinion_id'] = opinionId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
