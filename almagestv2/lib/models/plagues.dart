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
  String? secondname;

  PlagueData({
    this.id,
    this.name,
    this.secondname,
  });

  PlagueData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    secondname = json['secondname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
