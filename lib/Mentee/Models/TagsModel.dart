class TagsModel {
  bool? status;
  List<String>? data;

  TagsModel({this.status, this.data});

  TagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['tags'] = this.data;
    return data;
  }
}
