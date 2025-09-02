class SessionDetailsModel {
  bool? status;
  Session? session;

  SessionDetailsModel({this.status, this.session});

  SessionDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    session =
    json['session'] != null ? new Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.session != null) {
      data['session'] = this.session!.toJson();
    }
    return data;
  }
}

class Session {
  int? id;
  String? date;
  Mentor? mentor;
  Mentee? mentee;
  String? topics;
  String? minutesLeft;
  String? status;
  int? sessionCost;
  String? zoomLink;
  String? attachment;

  Session(
      {this.id,
        this.date,
        this.mentor,
        this.mentee,
        this.topics,
        this.minutesLeft,
        this.status,
        this.sessionCost,
        this.zoomLink,
        this.attachment});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    mentor =
    json['mentor'] != null ? new Mentor.fromJson(json['mentor']) : null;
    mentee =
    json['mentee'] != null ? new Mentee.fromJson(json['mentee']) : null;
    topics = json['topics'];
    minutesLeft = json['minutes_left'];
    status = json['status'];
    sessionCost = json['session_cost'];
    zoomLink = json['zoom_link'];
    attachment = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    if (this.mentor != null) {
      data['mentor'] = this.mentor!.toJson();
    }
    if (this.mentee != null) {
      data['mentee'] = this.mentee!.toJson();
    }
    data['topics'] = this.topics;
    data['minutes_left'] = this.minutesLeft;
    data['status'] = this.status;
    data['session_cost'] = this.sessionCost;
    data['zoom_link'] = this.zoomLink;
    data['attachment'] = this.attachment;
    return data;
  }
}

class Mentor {
  int? id;
  String? name;
  String? college;
  String? profile;

  Mentor({this.id, this.name, this.college, this.profile});

  Mentor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    college = json['college'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['college'] = this.college;
    data['profile'] = this.profile;
    return data;
  }
}

class Mentee {
  int? id;
  String? name;
  String? profile;
  String? collegeName;

  Mentee({this.id, this.name, this.profile,this.collegeName});

  Mentee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profile = json['profile'];
    collegeName = json['college'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile'] = this.profile;
    data['college'] = this.collegeName;
    return data;
  }
}
