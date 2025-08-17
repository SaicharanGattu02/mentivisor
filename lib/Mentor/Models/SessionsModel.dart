class SessionsModel {
  bool? status;
  int? count;
  List<Data>? data;

  SessionsModel({this.status, this.count, this.data});

  SessionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
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
  dynamic topics;
  String? startTime;
  String? endTime;
  int? sessionCost;
  String? status;
  String? zoomLink;

  Data(
      {this.id,
        this.mentor,
        this.mentee,
        this.date,
        this.topics,
        this.startTime,
        this.endTime,
        this.sessionCost,
        this.status,
        this.zoomLink});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mentor =
    json['mentor'] != null ? new Mentor.fromJson(json['mentor']) : null;
    mentee =
    json['mentee'] != null ? new Mentee.fromJson(json['mentee']) : null;
    date = json['date'];
    topics = json['topics'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    sessionCost = json['session_cost'];
    status = json['status'];
    zoomLink = json['zoom_link'];
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
