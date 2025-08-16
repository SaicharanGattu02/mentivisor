class DailySlotsModel {
  bool? status;
  String? date;
  String? costPerMinute;
  int? totalSlots;
  List<Slots>? slots;

  DailySlotsModel(
      {this.status,
        this.date,
        this.costPerMinute,
        this.totalSlots,
        this.slots});

  DailySlotsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    costPerMinute = json['cost_per_minute'];
    totalSlots = json['total_slots'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    data['cost_per_minute'] = this.costPerMinute;
    data['total_slots'] = this.totalSlots;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  int? id;
  String? startTime;
  String? endTime;
  String? timeLabel;
  int? durationMinutes;
  int? sessionCost;
  bool? isBooked;

  Slots(
      {this.id,
        this.startTime,
        this.endTime,
        this.timeLabel,
        this.durationMinutes,
        this.sessionCost,
        this.isBooked});

  Slots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    timeLabel = json['time_label'];
    durationMinutes = json['duration_minutes'];
    sessionCost = json['session_cost'];
    isBooked = json['is_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['time_label'] = this.timeLabel;
    data['duration_minutes'] = this.durationMinutes;
    data['session_cost'] = this.sessionCost;
    data['is_booked'] = this.isBooked;
    return data;
  }
}
