class CampusesModel {
  bool? status;
  List<Data>? data;

  CampusesModel({this.status, this.data});

  CampusesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? state;
  String? city;
  String? dist;
  String? pincode;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? activeStatus;

  Data(
      {this.id,
        this.name,
        this.state,
        this.city,
        this.dist,
        this.pincode,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.activeStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    state = json['State'];
    city = json['City'];
    dist = json['Dist'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['State'] = this.state;
    data['City'] = this.city;
    data['Dist'] = this.dist;
    data['pincode'] = this.pincode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    return data;
  }
}
