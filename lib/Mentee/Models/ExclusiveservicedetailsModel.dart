class ExclusiveservicedetailsModel {
  bool? status;
  Data? data;
  String? message;

  ExclusiveservicedetailsModel({this.status, this.data,this.message});

  ExclusiveservicedetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['error'];
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
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  String? link;
  String? exclusiveService;

  Data(
      {this.id,
        this.name,
        this.description,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.link,
        this.exclusiveService});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    link = json['link'];
    exclusiveService = json['exclusive_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['link'] = this.link;
    data['exclusive_service'] = this.exclusiveService;
    return data;
  }
}
