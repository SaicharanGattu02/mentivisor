class AvailableSlotsModel {
  bool? status;
  List<RecentSlots>? recentSlots;

  AvailableSlotsModel({this.status, this.recentSlots});

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['recent_slots'] != null) {
      recentSlots = <RecentSlots>[];
      json['recent_slots'].forEach((v) {
        recentSlots!.add(new RecentSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.recentSlots != null) {
      data['recent_slots'] = this.recentSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentSlots {
  int? mentorId;
  String? date;
  String? startTime;
  String? endTime;
  int? repeatWeekly;
  int? slots;
  String? updatedAt;
  String? createdAt;
  int? id;

  RecentSlots({
    this.mentorId,
    this.date,
    this.startTime,
    this.endTime,
    this.repeatWeekly,
    this.slots,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  RecentSlots.fromJson(Map<String, dynamic> json) {
    mentorId = json['mentor_id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    repeatWeekly = json['repeat_weekly'];
    slots = json['slots'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentor_id'] = this.mentorId;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['repeat_weekly'] = this.repeatWeekly;
    data['slots'] = this.slots;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
