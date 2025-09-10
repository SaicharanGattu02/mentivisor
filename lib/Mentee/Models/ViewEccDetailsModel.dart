class ViewEccDetailsModel {
  bool? status;
  String? message;
  Data? data;

  ViewEccDetailsModel({this.status, this.data, this.message});

  ViewEccDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? location;
  String? type;
  String? time;
  String? dateofevent;
  Null? tags;
  String? college;
  String? description;
  String? link;
  String? image;
  int? popular;
  int? uploadedBy;
  int? collegeId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  dynamic coins;
  String? imgUrl;

  Data(
      {this.id,
        this.name,
        this.location,
        this.type,
        this.time,
        this.dateofevent,
        this.tags,
        this.college,
        this.description,
        this.link,
        this.image,
        this.popular,
        this.uploadedBy,
        this.collegeId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.activeStatus,
        this.coins,
        this.imgUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    type = json['type'];
    time = json['time'];
    dateofevent = json['dateofevent'];
    tags = json['tags'];
    college = json['college'];
    description = json['description'];
    link = json['link'];
    image = json['image'];
    popular = json['popular'];
    uploadedBy = json['uploaded_by'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    coins = json['coins'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['type'] = this.type;
    data['time'] = this.time;
    data['dateofevent'] = this.dateofevent;
    data['tags'] = this.tags;
    data['college'] = this.college;
    data['description'] = this.description;
    data['link'] = this.link;
    data['image'] = this.image;
    data['popular'] = this.popular;
    data['uploaded_by'] = this.uploadedBy;
    data['college_id'] = this.collegeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    data['coins'] = this.coins;
    data['img_url'] = this.imgUrl;
    return data;
  }
}
