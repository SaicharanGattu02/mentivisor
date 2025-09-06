class AvailableSlotsModel {
  bool? status;
  RecentSlots? recentSlots;

  AvailableSlotsModel({this.status, this.recentSlots});

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    recentSlots = json['recent_slots'] != null
        ? RecentSlots.fromJson(json['recent_slots'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.recentSlots != null) {
      data['recent_slots'] = this.recentSlots!.toJson();
    }
    return data;
  }
}

class RecentSlots {
  String? filter;
  String? range;
  String? duration;
  List<String>? uniqueDates;
  List<UniqueTimeSlot>? uniqueTimeSlots;
  int? totalSlots;
  StatusCounts? statusCounts;
  List<DaySlot>? days;

  RecentSlots(
      {this.filter,
        this.range,
        this.duration,
        this.uniqueDates,
        this.uniqueTimeSlots,
        this.totalSlots,
        this.statusCounts,
        this.days});

  RecentSlots.fromJson(Map<String, dynamic> json) {
    filter = json['filter'];
    range = json['range'];
    duration = json['duration'];
    uniqueDates = List<String>.from(json['unique_dates']);
    if (json['unique_time_slots'] != null) {
      uniqueTimeSlots = [];
      json['unique_time_slots'].forEach((v) {
        uniqueTimeSlots!.add(UniqueTimeSlot.fromJson(v));
      });
    }
    totalSlots = json['total_slots'];
    statusCounts = json['status_counts'] != null
        ? StatusCounts.fromJson(json['status_counts'])
        : null;
    if (json['days'] != null) {
      days = [];
      json['days'].forEach((v) {
        days!.add(DaySlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filter'] = this.filter;
    data['range'] = this.range;
    data['duration'] = this.duration;
    data['unique_dates'] = this.uniqueDates;
    if (this.uniqueTimeSlots != null) {
      data['unique_time_slots'] =
          this.uniqueTimeSlots!.map((v) => v.toJson()).toList();
    }
    data['total_slots'] = this.totalSlots;
    if (this.statusCounts != null) {
      data['status_counts'] = this.statusCounts!.toJson();
    }
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UniqueTimeSlot {
  String? time;
  String? status;

  UniqueTimeSlot({this.time, this.status});

  UniqueTimeSlot.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}

class StatusCounts {
  int? active;
  int? booked;

  StatusCounts({this.active, this.booked});

  StatusCounts.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    booked = json['booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['booked'] = this.booked;
    return data;
  }
}

class DaySlot {
  String? date;
  int? count;
  StatusCounts? statusCounts;
  List<TimeSlot>? slots;

  DaySlot({this.date, this.count, this.statusCounts, this.slots});

  DaySlot.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    count = json['count'];
    statusCounts = json['status_counts'] != null
        ? StatusCounts.fromJson(json['status_counts'])
        : null;
    if (json['slots'] != null) {
      slots = [];
      json['slots'].forEach((v) {
        slots!.add(TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['count'] = this.count;
    if (this.statusCounts != null) {
      data['status_counts'] = this.statusCounts!.toJson();
    }
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  String? time;
  String? status;

  TimeSlot({this.time, this.status});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}
