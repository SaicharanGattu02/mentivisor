class MenteeCustmor_supportModel {
  bool? status;
  Data? data;
  String? msg;

  MenteeCustmor_supportModel({this.status, this.data, this.msg});

  MenteeCustmor_supportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? description;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.description,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
