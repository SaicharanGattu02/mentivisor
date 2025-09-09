class UploadFileInChatModel {
  bool? success;
  String? url;

  UploadFileInChatModel({this.success, this.url});

  UploadFileInChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['url'] = this.url;
    return data;
  }
}
