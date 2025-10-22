class TagsModel {
  bool? status;
  List<String>? data;

  TagsModel({this.status, this.data});

  TagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>?)?.cast<String>();
    } else if (json['tags'] != null) {
      data = (json['tags'] as List<dynamic>?)?.cast<String>();
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['status'] = status;
    dataMap['data'] = data; // Always sending 'data' when posting/updating
    return dataMap;
  }
}
