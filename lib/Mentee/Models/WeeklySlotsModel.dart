class WeeklySlotsModel {
  bool? status;
  WeekRange? weekRange;
  List<Days>? days;

  WeeklySlotsModel({this.status, this.weekRange, this.days});

  WeeklySlotsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    weekRange = json['week_range'] != null
        ? new WeekRange.fromJson(json['week_range'])
        : null;
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.weekRange != null) {
      data['week_range'] = this.weekRange!.toJson();
    }
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekRange {
  String? start;
  String? end;

  WeekRange({this.start, this.end});

  WeekRange.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class Days {
  String? date;
  String? day;
  String? dayNum;
  String? month;
  int? slotCount;

  Days({this.date, this.day, this.dayNum, this.month, this.slotCount});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    dayNum = json['day_num'];
    month = json['month'];
    slotCount = json['slot_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['day_num'] = this.dayNum;
    data['month'] = this.month;
    data['slot_count'] = this.slotCount;
    return data;
  }
}
