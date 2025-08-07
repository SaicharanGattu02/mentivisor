class StudyZoneReportModel {
  bool? status;
  String? message;
  Data? data;

  StudyZoneReportModel({this.status, this.message, this.data});

  StudyZoneReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? contentType;
  String? contentId;
  String? reason;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.contentType,
        this.contentId,
        this.reason,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    contentType = json['content_type'];
    contentId = json['content_id'];
    reason = json['reason'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_type'] = this.contentType;
    data['content_id'] = this.contentId;
    data['reason'] = this.reason;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
