class MyMenteesReportModel {
  bool? status;
  String? message;
  Data? data;

  MyMenteesReportModel({this.status, this.message, this.data});

  MyMenteesReportModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? mentorId;
  String? menteeId;
  String? sessionId;
  String? reason;
  String? createdAt;

  Data(
      {this.id,
        this.mentorId,
        this.menteeId,
        this.sessionId,
        this.reason,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mentorId = json['mentor_id'];
    menteeId = json['mentee_id'];
    sessionId = json['session_id'];
    reason = json['reason'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mentor_id'] = this.mentorId;
    data['mentee_id'] = this.menteeId;
    data['session_id'] = this.sessionId;
    data['reason'] = this.reason;
    data['created_at'] = this.createdAt;
    return data;
  }
}
