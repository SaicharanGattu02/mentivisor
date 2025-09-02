class MentorCoinHistoryModel {
  bool? status;
  int? count;
  List<Data>? data;

  MentorCoinHistoryModel({this.status, this.count, this.data});

  MentorCoinHistoryModel.fromJson(Map<String, dynamic> json) {
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
  int? sessionId;
  String? activity;
  String? coins;
  String? date;

  Data({this.id, this.sessionId, this.activity, this.coins, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['session_id'];
    activity = json['activity'];
    coins = json['coins'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['session_id'] = this.sessionId;
    data['activity'] = this.activity;
    data['coins'] = this.coins;
    data['date'] = this.date;
    return data;
  }
}
