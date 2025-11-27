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
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (recentSlots != null) {
      data['recent_slots'] = recentSlots!.toJson();
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

  RecentSlots({
    this.filter,
    this.range,
    this.duration,
    this.uniqueDates,
    this.uniqueTimeSlots,
    this.totalSlots,
    this.statusCounts,
    this.days,
  });

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
    final data = <String, dynamic>{};
    data['filter'] = filter;
    data['range'] = range;
    data['duration'] = duration;
    data['unique_dates'] = uniqueDates;

    if (uniqueTimeSlots != null) {
      data['unique_time_slots'] =
          uniqueTimeSlots!.map((v) => v.toJson()).toList();
    }

    data['total_slots'] = totalSlots;

    if (statusCounts != null) {
      data['status_counts'] = statusCounts!.toJson();
    }

    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
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
    return {
      'time': time,
      'status': status,
    };
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
    return {
      'active': active,
      'booked': booked,
    };
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
    final data = <String, dynamic>{};
    data['date'] = date;
    data['count'] = count;

    if (statusCounts != null) {
      data['status_counts'] = statusCounts!.toJson();
    }

    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class TimeSlot {
  int? id;
  String? time;
  String? status;

  TimeSlot({this.id, this.time, this.status});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'status': status,
    };
  }
}
