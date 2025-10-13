class TagsModel {
  bool? status;
  List<String>? data;

  TagsModel({this.status, this.data});

  TagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] as List<dynamic>?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['status'] = status;
    dataMap['data'] = data;
    return dataMap;
  }
}

