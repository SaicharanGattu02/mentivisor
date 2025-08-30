class NotificationModel {
  bool? status;
  String? message;
  Data? data;

  NotificationModel({this.status, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}


class Data {
  List<Session>? session;
  List<Reminder>? reminder;
  List<Reward>? rewards;
  List<Rejections>? rejections;

  Data({this.session, this.reminder, this.rewards, this.rejections});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['session'] != null) {
      session = (json['session'] as List)
          .map((v) => Session.fromJson(v))
          .toList();
    }
    if (json['reminder'] != null) {
      reminder = (json['reminder'] as List)
          .map((v) => Reminder.fromJson(v))
          .toList();
    }
    if (json['rewards'] != null) {
      rewards = (json['rewards'] as List)
          .map((v) => Reward.fromJson(v))
          .toList();
    }
    if (json['rejections'] != null) {
      rejections = (json['rejections'] as List)
          .map((v) => Rejections.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (session != null) {
      map['session'] = session!.map((v) => v.toJson()).toList();
    }
    if (reminder != null) {
      map['reminder'] = reminder!.map((v) => v.toJson()).toList();
    }
    if (rewards != null) {
      map['rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    if (rejections != null) {
      map['rejections'] = rejections!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Session {
  int? id;
  String? title;
  String? date;

  Session({this.id, this.title, this.date});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['date'] = date;
    return map;
  }
}

class Reminder {
  int? id;
  String? message;
  String? date;

  Reminder({this.id, this.message, this.date});

  Reminder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['message'] = message;
    map['date'] = date;
    return map;
  }
}

class Reward {
  int? id;
  String? description;
  String? date;

  Reward({this.id, this.description, this.date});

  Reward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['description'] = description;
    map['date'] = date;
    return map;
  }
}

class Rejections {
  int? id;
  String? message;
  String? date;

  Rejections({this.id, this.message, this.date});

  Rejections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['message'] = message;
    map['date'] = date;
    return map;
  }
}
