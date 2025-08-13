class CampusesModel {
  bool? status;
  List<CampusData>? data;

  CampusesModel({this.status, this.data});

  CampusesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null &&
        json['data'] is Map &&
        json['data']['data'] != null) {
      data = (json['data']['data'] as List)
          .map((e) => CampusData.fromJson(e))
          .toList();
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data?.map((v) => v.toJson()).toList()};
  }
}

class CampusData {
  int? id;
  String? name;
  String? state;
  String? city;
  String? dist;
  String? pincode;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;

  CampusData({
    this.id,
    this.name,
    this.state,
    this.city,
    this.dist,
    this.pincode,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
  });

  CampusData.fromJson(Map<String, dynamic> json) {
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
    return {
      'id': id,
      'Name': name,
      'State': state,
      'City': city,
      'Dist': dist,
      'pincode': pincode,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'active_status': activeStatus,
    };
  }
}
