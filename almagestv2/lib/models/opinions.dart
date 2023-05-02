class Opinions {
  bool? success;
  List<OpinionData>? data;
  String? message;

  Opinions({this.success, this.data, this.message});

  Opinions.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OpinionData>[];
      json['data'].forEach((v) {
        data!.add(OpinionData.fromJson(v));
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

class OpinionData {
  int? id;
  String? headline;
  String? description;
  int? plagueId;
  String? plagueName;
  int? numLikes;
  int? deleted;
  String? createdAt;
  String? updatedAt;

  OpinionData(
      {this.id,
      this.headline,
      this.description,
      this.plagueId,
      this.plagueName,
      this.numLikes,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  OpinionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headline = json['headline'];
    description = json['description'];
    plagueId = json['plague_id'];
    plagueName = json['plague_name'];
    numLikes = json['num_likes'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['headline'] = headline;
    data['description'] = description;
    data['company_id'] = plagueId;
    data['plagueName'] = plagueName;
    data['num_likes'] = numLikes;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
