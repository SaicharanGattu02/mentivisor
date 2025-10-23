class MyMenteesModel {
  bool? status;
  String? message;
  Data? data;

  MyMenteesModel({this.status, this.message, this.data});

  MyMenteesModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<MenteeData>? menteeData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.menteeData,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      menteeData = <MenteeData>[];
      json['data'].forEach((v) {
        menteeData!.add(new MenteeData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.menteeData != null) {
      data['data'] = this.menteeData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class MenteeData {
  int? id;
  String? name;
  String? email;
  String? profilePic;
  String? status;
  String? lastInteractedDate;
  String? college;
  List<SessionDetails>? sessionDetails;

  MenteeData({
    this.id,
    this.name,
    this.email,
    this.profilePic,
    this.status,
    this.lastInteractedDate,
    this.college,
    this.sessionDetails,
  });

  MenteeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    status = json['status'];
    lastInteractedDate = json['last_interacted_date'];
    college = json['college'];
    if (json['session_details'] != null) {
      sessionDetails = <SessionDetails>[];
      json['session_details'].forEach((v) {
        sessionDetails!.add(new SessionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['status'] = this.status;
    data['last_interacted_date'] = this.lastInteractedDate;
    data['college'] = this.college;
    if (this.sessionDetails != null) {
      data['session_details'] = this.sessionDetails!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class SessionDetails {
  int? id;
  String? sessionDate;
  String? startTime;
  String? endTime;
  String? mentorName;

  SessionDetails({
    this.id,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.mentorName,
  });

  SessionDetails.fromJson(Map<String, dynamic> json) {
    sessionDate = json['session_date'];
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    mentorName = json['mentor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_date'] = this.sessionDate;
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['mentor_name'] = this.mentorName;
    return data;
  }
}

class LastSession {
  int? sessionId;
  String? date;
  String? time;
  String? status;

  LastSession({this.sessionId, this.date, this.time, this.status});

  LastSession.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
