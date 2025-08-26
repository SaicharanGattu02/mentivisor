class SessionBookingModel {
  bool? status;
  String? message;
  Data? data;

  SessionBookingModel({this.status, this.message, this.data});

  SessionBookingModel.fromJson(Map<String, dynamic> json) {
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
  Booking? booking;
  int? walletBalance;

  Data({this.booking, this.walletBalance});

  Data.fromJson(Map<String, dynamic> json) {
    booking = json['booking'] != null
        ? new Booking.fromJson(json['booking'])
        : null;
    walletBalance = json['wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    data['wallet_balance'] = this.walletBalance;
    return data;
  }
}

class Booking {
  int? mentorId;
  int? menteeId;
  int? availabilityId;
  String? sessionDate;
  String? startTime;
  String? endTime;
  String? sessionType;
  String? topic;
  String? attachment;
  int? sessionCost;
  String? zoomJoinUrl;
  String? zoomStartUrl;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Booking({
    this.mentorId,
    this.menteeId,
    this.availabilityId,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.sessionType,
    this.topic,
    this.attachment,
    this.sessionCost,
    this.zoomJoinUrl,
    this.zoomStartUrl,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    mentorId = json['mentor_id'];
    menteeId = json['mentee_id'];
    availabilityId = json['availability_id'];
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    sessionType = json['session_type'];
    topic = json['topic'];
    attachment = json['attachment'];
    sessionCost = json['session_cost'];
    zoomJoinUrl = json['zoom_join_url'];
    zoomStartUrl = json['zoom_start_url'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentor_id'] = this.mentorId;
    data['mentee_id'] = this.menteeId;
    data['availability_id'] = this.availabilityId;
    data['session_date'] = this.sessionDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['session_type'] = this.sessionType;
    data['topic'] = this.topic;
    data['attachment'] = this.attachment;
    data['session_cost'] = this.sessionCost;
    data['zoom_join_url'] = this.zoomJoinUrl;
    data['zoom_start_url'] = this.zoomStartUrl;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
