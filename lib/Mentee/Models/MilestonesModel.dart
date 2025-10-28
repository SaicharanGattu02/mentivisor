class MilestonesModel {
  bool? status;
  String? userId;
  String? month;
  List<Milestones>? milestones;

  MilestonesModel({this.status, this.userId, this.month, this.milestones});

  MilestonesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id']?.toString(); // 👈 Convert int → String
    month = json['month'];
    if (json['milestones'] != null) {
      milestones = <Milestones>[];
      json['milestones'].forEach((v) {
        milestones!.add(new Milestones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['month'] = this.month;
    if (this.milestones != null) {
      data['milestones'] = this.milestones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Milestones {
  String? type;
  int? target;
  int? completed;
  int? remaining;
  double? progressPercent; // Use double for percent
  String? status;
  int? coinsReward;

  Milestones({
    this.type,
    this.target,
    this.completed,
    this.remaining,
    this.progressPercent,
    this.status,
    this.coinsReward,
  });

  Milestones.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    target = _toInt(json['target']);
    completed = _toInt(json['completed']);
    remaining = _toInt(json['remaining']);
    progressPercent = _toDouble(json['progress_percent']);
    status = json['status']?.toString();
    coinsReward = _toInt(json['coins_reward']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['target'] = target;
    data['completed'] = completed;
    data['remaining'] = remaining;
    data['progress_percent'] = progressPercent;
    data['status'] = status;
    data['coins_reward'] = coinsReward;
    return data;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
