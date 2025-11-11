class UploadFileInChatModel {
  bool? success;
  String? url;
  String? message;

  UploadFileInChatModel({this.success, this.url, this.message});

  UploadFileInChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['url'] = this.url;
    return data;
  }
}
