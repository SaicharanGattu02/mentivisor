class ReviewSubmitModel {
  bool? status;
  String? message;
  Data? data;

  ReviewSubmitModel({this.status, this.message, this.data});

  ReviewSubmitModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? sessionId;
  int? rating;
  String? feedback;
  String? createdAt;

  Data(
      {this.id,
        this.mentorId,
        this.userId,
        this.sessionId,
        this.rating,
        this.feedback,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mentorId = json['mentor_id'];
    userId = json['user_id'];
    sessionId = json['session_id'];
    rating = json['rating'];
    feedback = json['feedback'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mentor_id'] = this.mentorId;
    data['user_id'] = this.userId;
    data['session_id'] = this.sessionId;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    data['created_at'] = this.createdAt;
    return data;
  }
}
