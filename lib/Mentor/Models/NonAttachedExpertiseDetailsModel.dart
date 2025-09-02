class NonAttachedExpertiseDetailsModel {
  bool? status;
  String? message;
  List<Data>? data;

  NonAttachedExpertiseDetailsModel({this.status, this.message, this.data});

  NonAttachedExpertiseDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? expertiseId;
  String? name;
  int? baseValue;

  Data({this.id, this.expertiseId, this.name, this.baseValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertiseId = json['expertise_id'];
    name = json['name'];
    baseValue = json['base_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expertise_id'] = this.expertiseId;
    data['name'] = this.name;
    data['base_value'] = this.baseValue;
    return data;
  }
}
