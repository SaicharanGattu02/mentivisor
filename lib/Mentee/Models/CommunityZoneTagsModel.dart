class CommunityZoneTagsModel {
  bool? status;
  List<String>? tags;

  CommunityZoneTagsModel({this.status, this.tags});

  CommunityZoneTagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['tags'] = this.tags;
    return data;
  }
}
