

class MyMenteesModel {
  bool? status;
  String? message;
  List<Data>? data;

  MyMenteesModel({this.status, this.message, this.data});

  MyMenteesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  int? menteeId;
  String? image;
  LastSession? lastSession;

  Data({this.name, this.menteeId, this.image, this.lastSession});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    menteeId = json['mentee_id'];
    image = json['image'];
    lastSession = json['last_session'] != null
        ? new LastSession.fromJson(json['last_session'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mentee_id'] = this.menteeId;
    data['image'] = this.image;
    if (this.lastSession != null) {
      data['last_session'] = this.lastSession!.toJson();
    }
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
