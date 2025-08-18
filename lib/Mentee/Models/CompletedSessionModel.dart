class CompletedSessionModel {
  bool? status;
  int? count;
  String? message;
  List<Data>? data;

  CompletedSessionModel({this.status, this.count, this.data, this.message});

  CompletedSessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    message = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    data['error'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  Mentor? mentor;
  Mentee? mentee;
  String? date;
  Null? topics;
  String? startTime;
  String? endTime;
  int? sessionCost;
  String? status;
  Null? zoomLink;
  bool? hasRating;
  int? rating;
  String? feedback;

  Data({
    this.id,
    this.mentor,
    this.mentee,
    this.date,
    this.topics,
    this.startTime,
    this.endTime,
    this.sessionCost,
    this.status,
    this.zoomLink,
    this.hasRating,
    this.rating,
    this.feedback,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mentor = json['mentor'] != null
        ? new Mentor.fromJson(json['mentor'])
        : null;
    mentee = json['mentee'] != null
        ? new Mentee.fromJson(json['mentee'])
        : null;
    date = json['date'];
    topics = json['topics'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    sessionCost = json['session_cost'];
    status = json['status'];
    zoomLink = json['zoom_link'];
    hasRating = json['has_rating'];
    rating = json['rating'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.mentor != null) {
      data['mentor'] = this.mentor!.toJson();
    }
    if (this.mentee != null) {
      data['mentee'] = this.mentee!.toJson();
    }
    data['date'] = this.date;
    data['topics'] = this.topics;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['session_cost'] = this.sessionCost;
    data['status'] = this.status;
    data['zoom_link'] = this.zoomLink;
    data['has_rating'] = this.hasRating;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    return data;
  }
}

class Mentor {
  int? id;
  String? name;
  String? mentorProfile;

  Mentor({this.id, this.name, this.mentorProfile});

  Mentor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mentorProfile = json['mentor_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mentor_profile'] = this.mentorProfile;
    return data;
  }
}

class Mentee {
  int? id;
  String? name;
  String? menteeProfile;

  Mentee({this.id, this.name, this.menteeProfile});

  Mentee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    menteeProfile = json['mentee_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mentee_profile'] = this.menteeProfile;
    return data;
  }
}
