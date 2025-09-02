class TagsModel {
  bool? status;
  List<String>? data;

  TagsModel({this.status, this.data});

  TagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
