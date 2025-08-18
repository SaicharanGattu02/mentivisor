class MyMenteesModel {
  bool? status;
  String? message;
  List<MenteeData>? data;

  MyMenteesModel({this.status, this.message, this.data});

  MyMenteesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      data = <MenteeData>[];
      // ✅ Handle map instead of list
      (json['data'] as Map<String, dynamic>).forEach((key, value) {
        data!.add(MenteeData.fromJson(value));
      });
    }
  }
}


class MenteeData {
  int? id;
  String? name;
  String? email;
  String? profilePic;
  String? status;
  String? college;
  List<SessionDetail>? sessionDetails;

  MenteeData({
    this.id,
    this.name,
    this.email,
    this.profilePic,
    this.status,
    this.college,
    this.sessionDetails,
  });

  MenteeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    status = json['status'];
    college = json['college'];

    if (json['session_details'] != null) {
      sessionDetails = <SessionDetail>[];
      json['session_details'].forEach((v) {
        sessionDetails!.add(SessionDetail.fromJson(v));
      });
    }
  }
}
class SessionDetail {
  String? sessionDate;
  String? startTime;
  String? endTime;
  String? mentorName;

  SessionDetail({this.sessionDate, this.startTime, this.endTime, this.mentorName});

  SessionDetail.fromJson(Map<String, dynamic> json) {
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    mentorName = json['mentor_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'session_date': sessionDate,
      'start_time': startTime,
      'end_time': endTime,
      'mentor_name': mentorName,
    };
  }
}



class SessionDetails {
  String? sessionDate;
  String? startTime;
  String? endTime;
  String? mentorName;

  SessionDetails({this.sessionDate, this.startTime, this.endTime, this.mentorName});

  SessionDetails.fromJson(Map<String, dynamic> json) {
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    mentorName = json['mentor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['session_date'] = sessionDate;
    result['start_time'] = startTime;
    result['end_time'] = endTime;
    result['mentor_name'] = mentorName;
    return result;
  }
}
