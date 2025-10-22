class GetHomeDilogModel {
  bool? status;
  Data? data;

  GetHomeDilogModel({this.status, this.data});

  GetHomeDilogModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
  String? image;
  String? title;
  String? description;
  String? url;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  String? imgUrl;

  Data(
      {this.id,
        this.image,
        this.title,
        this.description,
        this.url,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
        this.imgUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    data['img_url'] = this.imgUrl;
    return data;
  }
}
